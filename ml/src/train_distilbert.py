"""
M7 — DistilBERT (the transformer upgrade).

WHAT THIS IS
  Fine-tunes DistilBERT, a small pre-trained language model, to classify job
  posts as scam / legit, then compares it to the classical model and the rule
  baseline on the SAME test set.

WHY A TRANSFORMER (vs TF-IDF + Logistic Regression)
  TF-IDF treats text as a bag of independent words — it cannot tell that
  "no fee required" and "fee required" mean opposite things, because word ORDER
  and CONTEXT are lost. A transformer reads words IN CONTEXT. DistilBERT is a
  distilled (smaller/faster) version of BERT that already "understands" English
  from huge pre-training; "fine-tuning" nudges it with OUR labelled job posts.

WHY THIS MIGHT *NOT* WIN
  Transformers shine when context matters and you have lots of data. On this
  dataset the classical model is already very strong (F1 ~0.87). Whether
  DistilBERT beats it is an empirical question — and reporting that honestly
  (win OR lose) is itself a valid research result.

CPU NOTE (important)
  We train on CPU. To keep training to a sane time we (a) cap text length and
  (b) by default DOWN-SAMPLE the majority (legit) class so training is faster and
  less imbalanced. We still EVALUATE on the full, real-distribution test set, so
  the comparison stays fair. This sampling choice is documented in the report.

RUN  (after: pip install -r requirements-distilbert.txt)
  python src/train_distilbert.py                 # fast CPU defaults
  python src/train_distilbert.py --full --epochs 3   # full data, slower
"""

from __future__ import annotations

import argparse
import json
import os

import numpy as np
import pandas as pd
import torch
from datasets import Dataset
from sklearn.metrics import (
    accuracy_score,
    f1_score,
    precision_score,
    recall_score,
    roc_auc_score,
)
from transformers import (
    AutoModelForSequenceClassification,
    AutoTokenizer,
    Trainer,
    TrainingArguments,
)

from common import MODELS_DIR, RANDOM_STATE, REPORTS_DIR, TEST_CSV, TRAIN_CSV, ensure_dir

MODEL_CKPT = "distilbert-base-uncased"


def build_training_frame(neg_ratio: int, full: bool) -> pd.DataFrame:
    train = pd.read_csv(TRAIN_CSV)
    train["text"] = train["text"].fillna("")
    if full:
        return train
    pos = train[train["label"] == 1]
    neg = train[train["label"] == 0].sample(
        n=min(len(pos) * neg_ratio, (train["label"] == 0).sum()),
        random_state=RANDOM_STATE,
    )
    out = pd.concat([pos, neg]).sample(frac=1.0, random_state=RANDOM_STATE)
    return out


def compute_metrics(eval_pred):
    logits, labels = eval_pred
    # softmax -> probability of the "scam" class (index 1)
    probs = torch.softmax(torch.tensor(logits), dim=1).numpy()[:, 1]
    preds = (probs >= 0.5).astype(int)
    return {
        "accuracy": accuracy_score(labels, preds),
        "precision": precision_score(labels, preds, zero_division=0),
        "recall": recall_score(labels, preds, zero_division=0),
        "f1": f1_score(labels, preds, zero_division=0),
        "roc_auc": roc_auc_score(labels, probs),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--epochs", type=int, default=2)
    parser.add_argument("--max-length", type=int, default=128)
    parser.add_argument("--batch-size", type=int, default=16)
    parser.add_argument("--neg-ratio", type=int, default=3,
                        help="legit:scam ratio when down-sampling (ignored with --full)")
    parser.add_argument("--full", action="store_true",
                        help="train on the full imbalanced training set (slow on CPU)")
    args = parser.parse_args()

    torch.manual_seed(RANDOM_STATE)
    np.random.seed(RANDOM_STATE)

    train_df = build_training_frame(args.neg_ratio, args.full)
    test_df = pd.read_csv(TEST_CSV)
    test_df["text"] = test_df["text"].fillna("")
    print(
        f"Train: {len(train_df)} rows ({int(train_df['label'].sum())} scams) | "
        f"Test: {len(test_df)} rows ({int(test_df['label'].sum())} scams)"
    )

    tokenizer = AutoTokenizer.from_pretrained(MODEL_CKPT)

    def tok(batch):
        return tokenizer(batch["text"], truncation=True, max_length=args.max_length)

    train_ds = Dataset.from_pandas(train_df[["text", "label"]], preserve_index=False).map(
        tok, batched=True)
    test_ds = Dataset.from_pandas(test_df[["text", "label"]], preserve_index=False).map(
        tok, batched=True)

    model = AutoModelForSequenceClassification.from_pretrained(MODEL_CKPT, num_labels=2)

    out_dir = os.path.join(MODELS_DIR, "distilbert")
    ensure_dir(out_dir)
    targs = TrainingArguments(
        output_dir=os.path.join(out_dir, "checkpoints"),
        num_train_epochs=args.epochs,
        per_device_train_batch_size=args.batch_size,
        per_device_eval_batch_size=32,
        learning_rate=2e-5,
        logging_steps=50,
        report_to="none",
        seed=RANDOM_STATE,
    )

    trainer = Trainer(
        model=model,
        args=targs,
        train_dataset=train_ds,
        eval_dataset=test_ds,
        compute_metrics=compute_metrics,
        processing_class=tokenizer,
    )

    print("\nTraining DistilBERT (this is the slow part on CPU)...")
    trainer.train()

    print("\nEvaluating on the full test set...")
    metrics = trainer.evaluate()
    # Trainer prefixes eval metrics with "eval_"
    clean = {k.replace("eval_", ""): v for k, v in metrics.items()
             if k.startswith("eval_") and k not in ("eval_runtime", "eval_loss")}
    for key in ["accuracy", "precision", "recall", "f1", "roc_auc"]:
        if key in clean:
            print(f"{key:10s} {clean[key]:.3f}")

    # save model + tokenizer for reuse / optional serving
    trainer.save_model(out_dir)
    tokenizer.save_pretrained(out_dir)

    # save metrics for the report, alongside the classical/baseline numbers
    ensure_dir(REPORTS_DIR)
    payload = {
        "model": "distilbert-base-uncased (fine-tuned)",
        "training": {
            "rows": len(train_df),
            "epochs": args.epochs,
            "max_length": args.max_length,
            "down_sampled": not args.full,
            "neg_ratio": None if args.full else args.neg_ratio,
        },
        "test_metrics": {k: float(clean[k]) for k in
                         ["accuracy", "precision", "recall", "f1", "roc_auc"] if k in clean},
    }
    with open(os.path.join(REPORTS_DIR, "distilbert_metrics.json"), "w", encoding="utf-8") as fh:
        json.dump(payload, fh, indent=2)

    # show the 3-way comparison if the classical/baseline metrics exist
    cmp_path = os.path.join(REPORTS_DIR, "metrics.json")
    if os.path.exists(cmp_path):
        with open(cmp_path, encoding="utf-8") as fh:
            prev = json.load(fh)
        print("\n=== Comparison (test set) ===")
        print(f"{'metric':10s} {'rule':>8s} {'classical':>10s} {'distilbert':>11s}")
        for key in ["accuracy", "precision", "recall", "f1", "roc_auc"]:
            r = prev.get("rule_baseline", {}).get(key, float("nan"))
            c = prev.get("ml_model", {}).get(key, float("nan"))
            d = clean.get(key, float("nan"))
            print(f"{key:10s} {r:>8.3f} {c:>10.3f} {d:>11.3f}")

    print(f"\nSaved model -> {out_dir}")
    print(f"Saved metrics -> {REPORTS_DIR}\\distilbert_metrics.json")


if __name__ == "__main__":
    main()
