# TrustHire — ML Research Pipeline

This folder contains the **machine-learning side** of TrustHire's scam detector:
the dataset prep, the rule-engine baseline, the trained ML models, the evaluation,
and the inference API the Flutter app calls.

It is intentionally **self-contained** — nothing here depends on the Flutter code,
and the Flutter app talks to it only over HTTP (see `api/main.py`).

> **For someone new to ML:** read this top-to-bottom once. Each script is one stage
> of a pipeline. You run them in order; each produces files the next one consumes.

---

## The pipeline at a glance

```
data/fake_job_postings.csv          (you download this — milestone M1)
        │
        ▼  src/prepare_data.py       clean text + seeded 80/20 train/test split
   data/train.csv, data/test.csv
        │
        ├─► src/rule_baseline.py     run the ported rule engine on the test set  → baseline metrics
        │
        ▼  src/train_classical.py    TF-IDF + LogReg/NB/SVM → pick best
   models/model.joblib, models/vectorizer.joblib
        │
        ▼  src/evaluate.py           metrics + confusion matrix + ROC for ALL models
   reports/metrics.json, reports/*.png, reports/comparison.md
        │
        ▼  api/main.py               FastAPI loads the model; POST /predict → {score, risk_level, issues, positives}
        │
        ▼  (Flutter app calls the API over HTTP)
```

`src/train_distilbert.py` (milestone M7) is an **optional** upgrade that adds a
transformer model to the same comparison.

---

## One-time setup

### 1. Install Python 3.12
This project is pinned to **Python 3.12** (best wheel support for the whole stack).
Verify after installing:
```
python --version      # should print Python 3.12.x
```

### 2. Create and activate a virtual environment
A *virtual environment* is an isolated Python install just for this project, so its
package versions never clash with anything else on your machine.

```powershell
# from the ml/ folder
python -m venv .venv
.\.venv\Scripts\Activate.ps1     # PowerShell  (you should see (.venv) in your prompt)
```

### 3. Install the core dependencies
```
pip install -r requirements.txt
```
(Install `requirements-distilbert.txt` only later, when you reach M7.)

---

## Reproduce everything from scratch

```powershell
# 0. activate the venv (see above), from the ml/ folder
# 1. (M1) place fake_job_postings.csv in ml/data/   — see "Dataset" below
python src/prepare_data.py        # M2  → data/train.csv, data/test.csv
python src/rule_baseline.py       # M3  → baseline metrics
python src/train_classical.py     # M4  → models/*.joblib
python src/evaluate.py            # M5  → reports/ (metrics + plots + comparison)
# optional:
python src/train_distilbert.py    # M7  (needs requirements-distilbert.txt)

# run the API (M8):
uvicorn api.main:app --reload --port 8000
```

**Reproducibility guarantees:** every split and model uses a fixed seed
(`RANDOM_STATE = 42`); package versions are pinned in `requirements.txt`. Running
the steps above on the same dataset reproduces the same numbers.

---

## Dataset

**EMSCAD — Employment Scam Aegean Dataset** (~17,880 real job ads, labelled
`fraudulent` 0/1). Download via Kaggle: *"Real or Fake — Fake Job Posting Prediction"*.
Place the CSV at `ml/data/fake_job_postings.csv`.

License: open for academic research. Limitations (English-only, ~2012–2014,
US/UK-skewed, ~5% fraud) are discussed in the final report.

---

## Folder map

| Path | What it is |
|---|---|
| `requirements.txt` | core pinned dependencies (classical ML + API + report) |
| `requirements-distilbert.txt` | optional heavy deps for the DistilBERT upgrade |
| `data/` | the dataset + generated splits (git-ignored) |
| `src/prepare_data.py` | clean + seeded train/test split |
| `src/rule_baseline.py` | Python port of the Flutter rule engine (the baseline) |
| `src/train_classical.py` | TF-IDF + Logistic Regression / Naive Bayes / SVM |
| `src/train_distilbert.py` | optional transformer fine-tuning |
| `src/evaluate.py` | metrics, confusion matrix, ROC, model comparison |
| `src/explain.py` | top contributing words → human-readable reasons |
| `models/` | saved model artifacts (git-ignored) |
| `reports/` | metrics + plots for the report (git-ignored) |
| `api/main.py` | FastAPI inference server the app calls |
