"""
M5 — Evaluation & baseline comparison.

WHAT THIS DOES
  Produces the headline research artefact: a like-for-like comparison of the
  RULE BASELINE vs the ML model(s) on the SAME test set, with:
    - a metrics table (accuracy, precision, recall, F1, ROC-AUC)
    - a confusion matrix plot for the deployed ML model
    - an ROC-curve plot overlaying baseline vs ML
    - a threshold sweep so you can SEE the precision/recall trade-off
  Outputs go to ml/reports/ for the final PDF report.

WHY EACH METRIC (in scam-detector terms)
  - Accuracy : fraction correct overall — MISLEADING here (95% are legit).
  - Precision: of the posts we flagged as scam, how many really were? (false alarms)
  - Recall   : of the real scams, how many did we catch? (missed scams = danger)
  - F1       : harmonic mean of precision & recall — the honest single number.
  - ROC-AUC  : how well the score RANKS scams above legit, across all thresholds.

RUN
  python src/evaluate.py                 # evaluate at the saved threshold
  python src/evaluate.py --threshold 0.3 # try a different decision threshold
"""

from __future__ import annotations

import argparse
import json
import sys

import joblib
import matplotlib
import pandas as pd

matplotlib.use("Agg")  # render to files, no GUI window
import matplotlib.pyplot as plt  # noqa: E402
from sklearn.metrics import (  # noqa: E402
    accuracy_score,
    confusion_matrix,
    f1_score,
    precision_recall_curve,
    precision_score,
    recall_score,
    roc_auc_score,
    roc_curve,
)

from common import MODELS_DIR, REPORTS_DIR, TEST_CSV, ensure_dir  # noqa: E402
from rule_baseline import scam_proba as rule_scam_proba  # noqa: E402


def metrics_at(y_true, proba, threshold: float) -> dict:
    y_pred = [1 if p >= threshold else 0 for p in proba]
    tn, fp, fn, tp = confusion_matrix(y_true, y_pred).ravel()
    return {
        "accuracy": accuracy_score(y_true, y_pred),
        "precision": precision_score(y_true, y_pred, zero_division=0),
        "recall": recall_score(y_true, y_pred, zero_division=0),
        "f1": f1_score(y_true, y_pred, zero_division=0),
        "roc_auc": roc_auc_score(y_true, proba),
        "tn": int(tn), "fp": int(fp), "fn": int(fn), "tp": int(tp),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--threshold", type=float, default=None,
                        help="decision threshold for the ML model (default: saved)")
    args = parser.parse_args()

    try:
        test = pd.read_csv(TEST_CSV)
        pipe = joblib.load(f"{MODELS_DIR}/model.joblib")
        with open(f"{MODELS_DIR}/model_meta.json", encoding="utf-8") as fh:
            meta = json.load(fh)
    except FileNotFoundError as e:
        sys.exit(f"ERROR: {e}. Run prepare_data.py and train_classical.py first.")

    threshold = args.threshold if args.threshold is not None else meta["threshold"]
    y_true = test["label"].astype(int).tolist()

    # --- predictions ---
    ml_proba = pipe.predict_proba(test["text"].fillna(""))[:, 1]
    rule_proba = [rule_scam_proba(t) for t in test["raw_text"].fillna("")]

    rule_m = metrics_at(y_true, rule_proba, 0.5)
    ml_m = metrics_at(y_true, ml_proba, threshold)

    # --- print comparison table ---
    print(f"\nDeployed ML model: {meta['deployed_model']}   (threshold={threshold})\n")
    header = f"{'metric':10s} {'rule baseline':>15s} {'ML model':>12s}"
    print(header)
    print("-" * len(header))
    for key in ["accuracy", "precision", "recall", "f1", "roc_auc"]:
        print(f"{key:10s} {rule_m[key]:>15.3f} {ml_m[key]:>12.3f}")
    print(
        f"\nConfusion (ML): TN={ml_m['tn']} FP={ml_m['fp']} "
        f"FN={ml_m['fn']} TP={ml_m['tp']}"
    )

    # --- threshold sweep (the learning bit: watch precision vs recall trade) ---
    print("\nThreshold sweep for the ML model:")
    print(f"{'thr':>5s} {'precision':>10s} {'recall':>8s} {'f1':>7s}")
    best_f1, best_thr = -1.0, 0.5
    for thr in [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]:
        m = metrics_at(y_true, ml_proba, thr)
        print(f"{thr:>5.1f} {m['precision']:>10.3f} {m['recall']:>8.3f} {m['f1']:>7.3f}")
        if m["f1"] > best_f1:
            best_f1, best_thr = m["f1"], thr
    print(f"\nThreshold that maximises F1 on this test set: {best_thr} (F1={best_f1:.3f})")
    print("Lower threshold = catch more scams (higher recall) but more false alarms.")

    # --- save metrics json ---
    ensure_dir(REPORTS_DIR)
    out = {
        "threshold": threshold,
        "deployed_model": meta["deployed_model"],
        "rule_baseline": rule_m,
        "ml_model": ml_m,
        "all_classical_models": meta.get("results", {}),
        "f1_max_threshold": {"threshold": best_thr, "f1": best_f1},
    }
    with open(f"{REPORTS_DIR}/metrics.json", "w", encoding="utf-8") as fh:
        json.dump(out, fh, indent=2)

    # --- comparison markdown for the report ---
    with open(f"{REPORTS_DIR}/comparison.md", "w", encoding="utf-8") as fh:
        fh.write("# Rule baseline vs ML — test set comparison\n\n")
        fh.write(f"Deployed ML model: **{meta['deployed_model']}**, threshold {threshold}\n\n")
        fh.write("| Metric | Rule baseline | ML model |\n|---|---|---|\n")
        for key in ["accuracy", "precision", "recall", "f1", "roc_auc"]:
            fh.write(f"| {key} | {rule_m[key]:.3f} | {ml_m[key]:.3f} |\n")

    # --- plot 1: confusion matrix of the ML model ---
    cm = [[ml_m["tn"], ml_m["fp"]], [ml_m["fn"], ml_m["tp"]]]
    fig, ax = plt.subplots(figsize=(4, 4))
    ax.imshow(cm, cmap="Blues")
    ax.set_xticks([0, 1], ["legit", "scam"])
    ax.set_yticks([0, 1], ["legit", "scam"])
    ax.set_xlabel("Predicted")
    ax.set_ylabel("Actual")
    ax.set_title(f"Confusion matrix — {meta['deployed_model']}")
    for i in range(2):
        for j in range(2):
            ax.text(j, i, cm[i][j], ha="center", va="center",
                    color="black", fontsize=14)
    fig.tight_layout()
    fig.savefig(f"{REPORTS_DIR}/confusion_matrix_ml.png", dpi=150)
    plt.close(fig)

    # --- plot 2: ROC curves, baseline vs ML ---
    fpr_r, tpr_r, _ = roc_curve(y_true, rule_proba)
    fpr_m, tpr_m, _ = roc_curve(y_true, ml_proba)
    fig, ax = plt.subplots(figsize=(5, 5))
    ax.plot(fpr_m, tpr_m, label=f"ML ({ml_m['roc_auc']:.3f})")
    ax.plot(fpr_r, tpr_r, label=f"Rule ({rule_m['roc_auc']:.3f})")
    ax.plot([0, 1], [0, 1], "k--", label="random (0.500)")
    ax.set_xlabel("False positive rate")
    ax.set_ylabel("True positive rate")
    ax.set_title("ROC curve — ML vs rule baseline")
    ax.legend(loc="lower right")
    fig.tight_layout()
    fig.savefig(f"{REPORTS_DIR}/roc_curves.png", dpi=150)
    plt.close(fig)

    print(f"\nSaved reports to {REPORTS_DIR}\\ (metrics.json, comparison.md, *.png)")


if __name__ == "__main__":
    main()
