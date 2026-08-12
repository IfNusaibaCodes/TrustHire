"""
M6 — Explainability.

WHY THIS EXISTS
  A scam detector that just says "73% risky" with no reason is a black box users
  (and examiners) cannot trust. The old rule engine always told you WHICH red
  flags fired. We keep that property for the ML model.

HOW IT WORKS (for a linear model like Logistic Regression)
  The model is, under the hood, a weighted sum:
        score = w1*term1 + w2*term2 + ... + bias
  Each TF-IDF term has a learned weight w. A POSITIVE weight pushes a posting
  toward "scam"; a NEGATIVE weight pushes it toward "legit". For a given posting
  we multiply each present term's TF-IDF value by its weight to get that term's
  CONTRIBUTION, then surface the biggest contributors as reasons. This is honest:
  it is literally what drove the model's decision, not a guess.

  (This clean per-term explanation is exactly why we deploy Logistic Regression
   rather than the calibrated SVM — see DEPLOY_MODEL in train_classical.py.)

RUN
  python src/explain.py "paste a job post here to see why it is flagged"
"""

from __future__ import annotations

import sys

import joblib
import numpy as np

from common import MODELS_DIR, clean_text


def _load_pipeline():
    return joblib.load(f"{MODELS_DIR}/model.joblib")


def explain(text: str, pipe=None, top_k: int = 5) -> dict:
    """Return the top scam-pushing and legit-pushing terms for one posting.

    Output: {"scam_terms": [(term, contribution), ...],
             "legit_terms": [(term, contribution), ...]}
    Contributions are signed: positive => toward scam, negative => toward legit.
    """
    pipe = pipe or _load_pipeline()
    vectorizer = pipe.named_steps["tfidf"]
    clf = pipe.named_steps["clf"]

    # Only linear models expose per-term weights via coef_.
    coef = getattr(clf, "coef_", None)
    if coef is None:
        return {"scam_terms": [], "legit_terms": []}
    weights = coef[0]

    x = vectorizer.transform([clean_text(text)])
    x = x.tocoo()
    feature_names = vectorizer.get_feature_names_out()

    # contribution of each present term = tfidf_value * learned_weight
    contribs = [(feature_names[j], x.data[k] * weights[j])
                for k, j in enumerate(x.col)]
    contribs.sort(key=lambda t: t[1])

    legit_terms = [(t, c) for t, c in contribs if c < 0][:top_k]
    scam_terms = [(t, c) for t, c in reversed(contribs) if c > 0][:top_k]
    return {"scam_terms": scam_terms, "legit_terms": legit_terms}


def to_reasons(
    text: str, pipe=None, top_k: int = 5, min_contrib: float = 0.05
) -> tuple[list[str], list[str]]:
    """Map the term contributions to UI-friendly issues / positives strings.

    `min_contrib` drops weak/noisy terms so we only surface words that actually
    moved the decision. Uses straight quotes to avoid any encoding surprises in
    the Flutter UI. Mirrors the shape the ScamResultCard already expects.
    """
    ex = explain(text, pipe=pipe, top_k=top_k)
    issues = [
        f"Scam-associated wording: '{t}'"
        for t, c in ex["scam_terms"] if c >= min_contrib
    ]
    positives = [
        f"Legitimate-looking wording: '{t}'"
        for t, c in ex["legit_terms"] if -c >= min_contrib
    ]
    return issues, positives


def main() -> None:
    if len(sys.argv) > 1:
        text = " ".join(sys.argv[1:])
    else:
        text = (
            "Congratulations! You have been selected. Pay a registration fee via "
            "bitcoin to start earning $5000 per week working from home. Contact us "
            "on whatsapp now!!"
        )

    pipe = _load_pipeline()
    proba = pipe.predict_proba([clean_text(text)])[0, 1]
    print(f"Scam probability: {proba:.3f}\n")

    ex = explain(text, pipe=pipe)
    print("Top terms pushing toward SCAM:")
    for term, c in ex["scam_terms"]:
        print(f"  +{c:.3f}  {term}")
    print("\nTop terms pushing toward LEGIT:")
    for term, c in ex["legit_terms"]:
        print(f"  {c:.3f}  {term}")


if __name__ == "__main__":
    main()
