"""
M8 — Inference API (FastAPI).

WHAT THIS IS
  A tiny HTTP server that loads the trained model ONCE at startup and answers
  POST /predict with the SAME result shape the Flutter app already renders:
      { "score": int(0-100), "risk_level": str, "issues": [str], "positives": [str] }
  The Flutter app calls this instead of (or with fallback to) the old rule engine.

WHY AN API INSTEAD OF ON-DEVICE
  scikit-learn pipelines don't convert cleanly to a phone runtime (TFLite), and
  this lets us upgrade the model later (e.g. DistilBERT) WITHOUT shipping a new
  app build. The app already speaks HTTP (Supabase, FCM), so this fits its style.

HOW SCORE MAPS TO THE UI
  The model outputs p = P(scam) in [0,1]. We show a "% safe" score = (1-p)*100,
  and band the risk so the existing ScamResultCard colours work unchanged.

RUN  (from the ml/ folder, venv active)
  uvicorn api.main:app --reload --port 8000
  # then open http://127.0.0.1:8000/docs  for an interactive test page
"""

from __future__ import annotations

import json
import os
import sys

import joblib
from fastapi import FastAPI
from pydantic import BaseModel, Field

# make ml/src importable whether launched from ml/ or elsewhere
_API_DIR = os.path.dirname(os.path.abspath(__file__))
_ML_DIR = os.path.dirname(_API_DIR)
sys.path.insert(0, os.path.join(_ML_DIR, "src"))

from common import MODELS_DIR, clean_text  # noqa: E402
from explain import to_reasons  # noqa: E402

# Words that suggest the text is a job/employment/offer message. Kept broad on
# purpose: real scams avoid formal job vocabulary ("job", "apply"), so a narrow
# list would wrongly reject genuine scams before the model ever sees them. This
# guard only exists to bounce clearly-unrelated text (e.g. a random screenshot).
_JOB_WORDS = (
    # formal job vocabulary
    "job", "hiring", "hire", "salary", "position", "vacancy", "vacancies",
    "apply", "application", "work", "employ", "employee", "employment",
    "candidate", "recruit", "recruitment", "company", "role", "opportunity",
    "interview", "cv", "resume", "staff", "career", "wage",
    # money / offer / scam vocabulary common in job scams
    "earn", "earning", "income", "pay", "payment", "fee", "deposit", "offer",
    "selected", "shortlisted", "remote", "wfh", "bonus", "commission",
)

# --- load model + config once at import time ---
_pipe = joblib.load(os.path.join(MODELS_DIR, "model.joblib"))
with open(os.path.join(MODELS_DIR, "model_meta.json"), encoding="utf-8") as _fh:
    _meta = json.load(_fh)
HIGH_T = float(_meta.get("threshold", 0.5))   # p >= HIGH_T  -> High Risk
MED_T = 0.30                                   # p >= MED_T   -> Medium Risk
MODEL_NAME = _meta.get("deployed_model", "unknown")

app = FastAPI(title="TrustHire Scam Detector API", version="1.0")


class PredictRequest(BaseModel):
    text: str = Field(..., description="Job-post text (typed or OCR'd).")


class PredictResponse(BaseModel):
    score: int
    risk_level: str
    issues: list[str]
    positives: list[str]
    scam_probability: float  # extra field for debugging; UI may ignore it


def _band(p: float) -> str:
    if p >= HIGH_T:
        return "High Risk"
    if p >= MED_T:
        return "Medium Risk"
    return "Low Risk"


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "model": MODEL_NAME, "high_threshold": HIGH_T}


@app.post("/predict", response_model=PredictResponse)
def predict(req: PredictRequest) -> PredictResponse:
    text = (req.text or "").strip()
    cleaned = clean_text(text)
    word_count = len(cleaned.split())

    # Guard: not a job post -> mirror the app's "Not Enough Info" behaviour.
    looks_like_job = any(w in cleaned for w in _JOB_WORDS)
    if word_count < 8 or not looks_like_job:
        return PredictResponse(
            score=0,
            risk_level="Not Enough Info",
            issues=[
                "This doesn't look like a job post.",
                "Paste the full job offer, email or message to get an accurate result.",
            ],
            positives=[],
            scam_probability=0.0,
        )

    p = float(_pipe.predict_proba([cleaned])[0, 1])
    score = int(round((1.0 - p) * 100))
    risk = _band(p)

    issues, positives = to_reasons(text, pipe=_pipe, top_k=4)
    # On a low-risk post the scam-term "issues" are weak/noisy — drop them so the
    # card shows mostly positives; on risky posts keep them as the "why".
    if risk == "Low Risk":
        issues = []
    elif risk == "High Risk":
        positives = []

    return PredictResponse(
        score=score,
        risk_level=risk,
        issues=issues,
        positives=positives,
        scam_probability=round(p, 4),
    )
