"""
M4 — Classical machine-learning models.

WHAT THIS DOES
  1. Loads the cleaned train/test splits.
  2. Turns text into numbers with TF-IDF (see note below).
  3. Trains THREE standard text classifiers:
        - Logistic Regression  (interpretable, gives probabilities)
        - Multinomial Naive Bayes (classic strong text baseline)
        - Linear SVM           (often top accuracy on text; calibrated for probs)
  4. Evaluates each on the TEST set, picks the best by F1, and saves it.

WHY TF-IDF
  Models do maths, not English. TF-IDF turns each posting into a vector of word
  scores: a word scores high if it is frequent IN THIS post but rare ACROSS all
  posts. So "the/and/job" fade out while distinctive words ("fee","wire","bonus")
  stand out. It is essentially a data-driven version of the keyword lists in the
  old rule engine — but the weights are LEARNED, not hand-set.

WHY THESE THREE MODELS (and why "classical" first)
  We start simple on purpose: these train in seconds on a CPU, are easy to
  interpret, and give us a strong, honest reference point before we reach for a
  heavy transformer (M7). If a 2-second Logistic Regression already beats the
  rules massively, that is a real, defensible result.

CLASS IMBALANCE
  Only ~5% of posts are scams, so we set class_weight="balanced" (where the model
  supports it). That tells the model "scam mistakes matter ~20x more than legit
  mistakes", stopping it from lazily predicting "legit" for everything.

RUN
  python src/train_classical.py
"""

from __future__ import annotations

import json
import sys

import joblib
import pandas as pd
from sklearn.calibration import CalibratedClassifierCV
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import f1_score, roc_auc_score
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
from sklearn.svm import LinearSVC

from common import (
    MODELS_DIR,
    RANDOM_STATE,
    TEST_CSV,
    TRAIN_CSV,
    ensure_dir,
)

# Which model the APP actually ships. We default to Logistic Regression because
# it is interpretable (clean per-word weights -> the "why" shown in the UI) and
# its accuracy is essentially tied with the SVM. Change to "linear_svm" if you
# want the highest raw F1 and are willing to give up easy explanations.
DEPLOY_MODEL = "logreg"


def build_vectorizer() -> TfidfVectorizer:
    """One shared TF-IDF configuration so every model is compared fairly."""
    return TfidfVectorizer(
        stop_words="english",     # drop "the/and/of" — no scam signal
        ngram_range=(1, 2),       # single words AND word-pairs ("wire transfer")
        min_df=5,                 # ignore words appearing in <5 posts (noise)
        max_features=50_000,      # cap vocabulary size for speed/memory
        sublinear_tf=True,        # dampen very high counts (log scaling)
    )


def candidate_models() -> dict[str, object]:
    """The three classifiers we compare. Each is wrapped with its own TF-IDF in
    a Pipeline so saving one file gives a self-contained text->prediction model."""
    return {
        "logreg": LogisticRegression(
            max_iter=1000,
            class_weight="balanced",
            random_state=RANDOM_STATE,
        ),
        "naive_bayes": MultinomialNB(),  # NB has no class_weight; priors handle it
        "linear_svm": CalibratedClassifierCV(
            # LinearSVC has no predict_proba, so we calibrate it to output
            # probabilities (needed for a 0-100 score and ROC-AUC).
            LinearSVC(class_weight="balanced", random_state=RANDOM_STATE),
            method="sigmoid",
            cv=3,
        ),
    }


def main() -> None:
    try:
        train = pd.read_csv(TRAIN_CSV)
        test = pd.read_csv(TEST_CSV)
    except FileNotFoundError:
        sys.exit("ERROR: run `python src/prepare_data.py` first.")

    X_train, y_train = train["text"].fillna(""), train["label"].astype(int)
    X_test, y_test = test["text"].fillna(""), test["label"].astype(int)

    print(f"Train: {len(X_train):,} rows ({int(y_train.sum())} scams)")
    print(f"Test : {len(X_test):,} rows ({int(y_test.sum())} scams)\n")

    ensure_dir(MODELS_DIR)
    results = []
    pipes: dict[str, Pipeline] = {}
    best_name, best_f1 = None, -1.0

    for name, clf in candidate_models().items():
        pipe = Pipeline([("tfidf", build_vectorizer()), ("clf", clf)])
        pipe.fit(X_train, y_train)

        proba = pipe.predict_proba(X_test)[:, 1]
        y_pred = (proba >= 0.5).astype(int)
        f1 = f1_score(y_test, y_pred, zero_division=0)
        auc = roc_auc_score(y_test, proba)
        results.append((name, f1, auc))
        pipes[name] = pipe
        print(f"{name:12s}  F1={f1:.3f}  ROC-AUC={auc:.3f}")

        # Save every model so the report can reference all of them and you can
        # switch the deployed model without retraining.
        joblib.dump(pipe, f"{MODELS_DIR}/model_{name}.joblib")

        if f1 > best_f1:
            best_name, best_f1 = name, f1

    # --- the DEPLOYED model (model.joblib) is what the API/app loads ---
    deployed = DEPLOY_MODEL if DEPLOY_MODEL in pipes else best_name
    joblib.dump(pipes[deployed], f"{MODELS_DIR}/model.joblib")

    meta = {
        "deployed_model": deployed,
        "best_by_f1": best_name,
        "threshold": 0.5,
        "random_state": RANDOM_STATE,
        "results": {n: {"f1": f1, "roc_auc": auc} for n, f1, auc in results},
    }
    with open(f"{MODELS_DIR}/model_meta.json", "w", encoding="utf-8") as fh:
        json.dump(meta, fh, indent=2)

    print(f"\nHighest F1: {best_name} (F1={best_f1:.3f})")
    print(f"Deployed model (model.joblib): {deployed}")
    print(f"Saved all models + model_meta.json -> {MODELS_DIR}")
    print("\nNext: python src/evaluate.py  (full comparison vs the rule baseline)")


if __name__ == "__main__":
    main()
