"""
M3 — Rule-engine baseline.

WHAT THIS IS
  A faithful Python port of the Flutter app's existing rule engine
  (lib/Pages/scam_detection/scam_analyzer.dart). It is our SCIENTIFIC CONTROL:
  the ML model must beat THIS to justify its existence.

WHY A BASELINE MATTERS
  In research you never report "the model got 0.9 F1" in a vacuum — 0.9 compared
  to WHAT? The honest question is "is the ML model actually better than the simple
  hand-written rules we already had?" So we run the exact same rules on the exact
  same test set and compare like-for-like.

HOW WE TURN RULES INTO A PROBABILITY
  The Dart engine returns a 0–100 "safety score". We convert it to a scam
  probability so it can be compared with the ML model (and get an ROC-AUC):
        p_scam = (100 - score) / 100
  A binary decision uses a threshold (default 0.5, i.e. score < 50 -> "scam").

RUN
  python src/rule_baseline.py          # prints baseline metrics on the test set
"""

from __future__ import annotations

import re
import sys
from dataclasses import dataclass, field

import pandas as pd

from common import TEST_CSV


@dataclass
class RuleResult:
    score: int
    risk_level: str
    issues: list[str] = field(default_factory=list)
    positives: list[str] = field(default_factory=list)


def _has(text_lower: str, words: list[str]) -> bool:
    return any(w in text_lower for w in words)


def analyze(input_text: str) -> RuleResult:
    """Port of ScamAnalyzer.analyze() — kept line-for-line faithful to the Dart.

    `input_text` should be the RAW (case-preserved) text, because the all-caps
    and punctuation checks depend on the original casing/symbols.
    """
    text = (input_text or "").lower()
    issues: list[str] = []
    positives: list[str] = []
    score = 100

    def flag(match: bool, issue: str, penalty: int) -> None:
        nonlocal score
        if match:
            issues.append(issue)
            score -= penalty

    def sign(match: bool, label: str) -> None:
        if match:
            positives.append(label)

    word_count = len([w for w in re.split(r"\s+", text) if w])

    looks_like_job_post = _has(
        text,
        [
            "job", "hiring", "salary", "position", "vacancy", "apply", "work",
            "employ", "candidate", "recruit", "company", "role", "opportunity",
        ],
    )

    if not text.strip():
        return RuleResult(0, "Unknown", ["No text provided"], [])

    if word_count < 8 or not looks_like_job_post:
        return RuleResult(
            0,
            "Not Enough Info",
            [
                "This doesn't look like a job post.",
                "Paste the full job offer, email or message to get an accurate result.",
            ],
            [],
        )

    flag(_has(text, ["urgent", "immediate", "act now", "limited slots", "hurry"]),
         "Urgent hiring pressure", 15)
    flag(_has(text, ["apply now", "don't miss", "last chance"]),
         "High-pressure call to action", 10)
    flag(_has(text, [
            "payment", "registration fee", "deposit", "processing fee",
            "training fee", "security deposit", "pay to", "send money",
            "advance payment",
         ]), "Requests upfront payment", 35)
    flag(_has(text, ["gift card", "bitcoin", "crypto", "usdt", "wire transfer",
                     "western union"]),
         "Asks for untraceable payment method", 30)
    flag(_has(text, [
            "bank account", "credit card", "national id", "ssn",
            "social security", "passport number", "pin number", "otp", "password",
         ]), "Requests sensitive personal/financial data", 30)
    flag(_has(text, ["gmail", "yahoo", "hotmail", "outlook.com"]),
         "Uses free email domain", 12)
    flag(_has(text, ["whatsapp", "telegram", "signal", "wechat"]),
         "Contact via unofficial messaging channel", 12)
    flag(
        _has(text, [
            "guaranteed income", "no experience needed", "earn from home",
            "work from home guaranteed", "easy money", "become rich",
            "unlimited earning",
        ]) or bool(re.search(r"\$?\d{4,}\s*(per day|/day|a day|per week|/week)", text)),
        "Unrealistic income promise", 20,
    )
    flag(bool(re.search(r"(salary|pay|earn).{0,15}\$?\s?\d{5,}", text)),
         "Salary looks too good to be true", 15)
    flag(
        bool(re.search(r"(congratulation|you have been selected|you are shortlisted)", text))
        and not _has(text, ["interview", "cv", "resume"]),
        "Selected without any interview/application", 20,
    )
    # All-caps check uses the ORIGINAL input (case matters here).
    flag(bool(re.search(r"[A-Z]{6,}", input_text or "")),
         "Excessive use of capital letters", 8)
    flag(bool(re.search(r"[!]{2,}", text)) or bool(re.search(r"\$\$+", text)),
         "Spammy punctuation/symbols", 8)

    sign(_has(text, ["website", ".com", "www.", "http"]), "Includes a company website")
    sign(_has(text, ["experience", "qualification", "requirements", "responsibilities"]),
         "Proper job description")
    sign(_has(text, ["interview", "cv", "resume", "application"]),
         "Mentions a real application/interview process")
    sign(_has(text, ["ltd", "limited", "inc", "corporation", "pvt"]),
         "Names a registered company")
    sign(_has(text, ["office", "address", "location"]), "Provides a physical location")

    score = max(0, min(100, score))

    if not issues and not positives:
        issues.append("Not enough detail to verify legitimacy")
        score = 60

    risk = "Low Risk" if score >= 75 else "Medium Risk" if score >= 45 else "High Risk"
    return RuleResult(score, risk, issues, positives)


def scam_proba(input_text: str) -> float:
    """Scam probability in [0,1] derived from the rule score, for ROC/comparison."""
    return (100 - analyze(input_text).score) / 100.0


def main() -> None:
    try:
        test = pd.read_csv(TEST_CSV)
    except FileNotFoundError:
        sys.exit(
            f"ERROR: {TEST_CSV} not found. Run `python src/prepare_data.py` first."
        )

    # Use raw_text so the case/punctuation rules work as the app intends.
    texts = test["raw_text"].fillna("").tolist()
    y_true = test["label"].astype(int).tolist()
    proba = [scam_proba(t) for t in texts]
    y_pred = [1 if p >= 0.5 else 0 for p in proba]

    # Metrics are reported here for a quick look; evaluate.py (M5) produces the
    # full side-by-side comparison and plots.
    from sklearn.metrics import (
        accuracy_score, precision_score, recall_score, f1_score, roc_auc_score,
        confusion_matrix,
    )

    print("=== Rule-engine baseline on the TEST set ===")
    print(f"Samples: {len(y_true)}  (scams: {sum(y_true)})")
    print(f"Accuracy : {accuracy_score(y_true, y_pred):.3f}")
    print(f"Precision: {precision_score(y_true, y_pred, zero_division=0):.3f}")
    print(f"Recall   : {recall_score(y_true, y_pred, zero_division=0):.3f}")
    print(f"F1       : {f1_score(y_true, y_pred, zero_division=0):.3f}")
    print(f"ROC-AUC  : {roc_auc_score(y_true, proba):.3f}")
    tn, fp, fn, tp = confusion_matrix(y_true, y_pred).ravel()
    print(f"Confusion matrix:  TN={tn}  FP={fp}  FN={fn}  TP={tp}")
    print(
        "\nRead this as: of the real scams, recall is the fraction we CAUGHT; "
        "precision is how often a 'scam' call was correct. Expect modest numbers "
        "— that's the bar the ML model must clear."
    )


if __name__ == "__main__":
    main()
