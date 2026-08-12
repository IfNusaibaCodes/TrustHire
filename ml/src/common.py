"""
Shared helpers used across the whole ML pipeline.

Keeping these in ONE place guarantees that data prep, training, evaluation, and
the API all clean text the SAME way. If the API cleaned text differently from how
the model was trained, predictions would silently degrade — a classic ML bug.
"""

from __future__ import annotations

import os
import re

# ---------------------------------------------------------------------------
# Reproducibility: every random operation in this project uses this one seed,
# so the train/test split and the trained models are identical on every run.
# ---------------------------------------------------------------------------
RANDOM_STATE = 42

# ---------------------------------------------------------------------------
# Paths (all relative to the ml/ folder, resolved absolutely so scripts work
# no matter which directory you launch them from).
# ---------------------------------------------------------------------------
ML_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))  # .../ml
DATA_DIR = os.path.join(ML_DIR, "data")
MODELS_DIR = os.path.join(ML_DIR, "models")
REPORTS_DIR = os.path.join(ML_DIR, "reports")

RAW_CSV = os.path.join(DATA_DIR, "fake_job_postings.csv")
TRAIN_CSV = os.path.join(DATA_DIR, "train.csv")
TEST_CSV = os.path.join(DATA_DIR, "test.csv")

# The EMSCAD free-text columns we merge into one document per posting.
# (Structured columns like telecommuting/has_company_logo are ignored here so
#  the model learns from LANGUAGE — the same thing OCR'd screenshots give us.)
TEXT_COLUMNS = [
    "title",
    "company_profile",
    "description",
    "requirements",
    "benefits",
]

# The label column: 1 = fraudulent/scam, 0 = legitimate.
LABEL_COLUMN = "fraudulent"


# EMSCAD anonymises URLs/emails/phones as placeholder tokens like #URL_abc#.
# They carry no language signal, so we strip them.
_PLACEHOLDER_RE = re.compile(r"#\w+_[0-9a-f]+#", re.IGNORECASE)
_HTML_RE = re.compile(r"<[^>]+>")
_WS_RE = re.compile(r"\s+")


def clean_text(text: str) -> str:
    """Cleaning for the ML MODEL (lowercased).

    We deliberately keep this SIMPLE (lowercase, strip html/placeholders/extra
    whitespace) and let the TF-IDF vectorizer handle stopwords and tokenisation.
    Over-cleaning can remove signal a scam detector needs.
    """
    if text is None:
        return ""
    text = str(text)
    text = _HTML_RE.sub(" ", text)
    text = _PLACEHOLDER_RE.sub(" ", text)
    text = text.lower()
    text = _WS_RE.sub(" ", text).strip()
    return text


def light_clean_keepcase(text: str) -> str:
    """Cleaning for the RULE BASELINE (case + punctuation PRESERVED).

    The ported Dart rule engine inspects ALL-CAPS runs and '!!' style
    punctuation, so we must NOT lowercase or strip symbols here. We only remove
    HTML tags (EMSCAD descriptions contain markup the app would never receive)
    and collapse whitespace. This keeps the baseline comparison fair.
    """
    if text is None:
        return ""
    text = str(text)
    text = _HTML_RE.sub(" ", text)
    text = _WS_RE.sub(" ", text).strip()
    return text


def ensure_dir(path: str) -> None:
    """Create a directory if it does not already exist."""
    os.makedirs(path, exist_ok=True)
