"""
M2 — Data preparation.

WHAT THIS DOES
  1. Loads the raw EMSCAD csv (ml/data/fake_job_postings.csv).
  2. Merges the free-text columns into one 'text' field per posting.
  3. Cleans the text (see common.clean_text).
  4. Splits into train/test (80/20) with a FIXED seed, STRATIFIED so the rare
     scam class keeps the same ~5% proportion in both halves.
  5. Saves data/train.csv and data/test.csv (columns: text,label).

WHY A TRAIN/TEST SPLIT
  We train the model on the TRAIN half and judge it on the TEST half it has
  never seen. That is the only honest way to estimate how it will behave on new,
  real job posts. Judging a model on data it trained on is like grading students
  on the exact questions they were given the answers to.

WHY STRATIFY
  Only ~5% of postings are scams. A plain random split could, by chance, put very
  few scams in the test set and make the metrics meaningless. Stratifying keeps
  the scam proportion identical in train and test.

RUN
  python src/prepare_data.py
"""

from __future__ import annotations

import sys

import pandas as pd
from sklearn.model_selection import train_test_split

from common import (
    LABEL_COLUMN,
    RANDOM_STATE,
    RAW_CSV,
    TEST_CSV,
    TEXT_COLUMNS,
    TRAIN_CSV,
    clean_text,
    light_clean_keepcase,
)


def main() -> None:
    try:
        df = pd.read_csv(RAW_CSV)
    except FileNotFoundError:
        sys.exit(
            f"\nERROR: dataset not found at:\n  {RAW_CSV}\n\n"
            "Download EMSCAD (Kaggle: 'Real or Fake — Fake Job Posting Prediction')\n"
            "and place fake_job_postings.csv in the ml/data/ folder, then re-run.\n"
        )

    print(f"Loaded {len(df):,} rows, {df.shape[1]} columns.")

    # --- sanity check the columns we depend on actually exist ---
    missing = [c for c in TEXT_COLUMNS + [LABEL_COLUMN] if c not in df.columns]
    if missing:
        sys.exit(
            f"ERROR: expected columns missing from the csv: {missing}\n"
            f"Columns present: {list(df.columns)}"
        )

    # --- merge the free-text columns into one document ---
    # Missing cells become empty strings so concatenation never produces 'nan'.
    for col in TEXT_COLUMNS:
        df[col] = df[col].fillna("")
    merged = df[TEXT_COLUMNS].agg(" ".join, axis=1)

    # Two views of the SAME merged text (same rows, same split):
    #   text     -> for the ML model (lowercased, cleaned)
    #   raw_text -> for the rule baseline (case + punctuation preserved)
    df["text"] = merged.map(clean_text)
    df["raw_text"] = merged.map(light_clean_keepcase)
    df["label"] = df[LABEL_COLUMN].astype(int)

    # --- drop rows that are empty after cleaning (no language to learn from) ---
    before = len(df)
    df = df[df["text"].str.len() > 0].copy()
    dropped = before - len(df)
    if dropped:
        print(f"Dropped {dropped} rows with empty text after cleaning.")

    # --- report class balance (the key dataset characteristic) ---
    n_scam = int(df["label"].sum())
    n_total = len(df)
    pct = 100.0 * n_scam / n_total
    print(
        f"Class balance: {n_scam:,} fraudulent / {n_total:,} total "
        f"({pct:.2f}% scam, {100 - pct:.2f}% legit)."
    )

    # --- stratified, seeded 80/20 split ---
    train_df, test_df = train_test_split(
        df[["text", "raw_text", "label"]],
        test_size=0.20,
        random_state=RANDOM_STATE,
        stratify=df["label"],
    )

    train_df.to_csv(TRAIN_CSV, index=False)
    test_df.to_csv(TEST_CSV, index=False)

    print(
        f"\nSaved:\n"
        f"  {TRAIN_CSV}  ({len(train_df):,} rows, "
        f"{int(train_df['label'].sum())} scams)\n"
        f"  {TEST_CSV}  ({len(test_df):,} rows, "
        f"{int(test_df['label'].sum())} scams)"
    )
    print("\nDone. Next: python src/rule_baseline.py")


if __name__ == "__main__":
    main()
