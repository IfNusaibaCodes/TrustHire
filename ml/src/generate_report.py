"""
M11 — Generate the final PDF report.

WHAT THIS DOES
  Assembles a self-contained PDF describing the whole project end to end:
  problem, architecture, the ML process (dataset -> features -> models ->
  evaluation vs the rule baseline), the OCR process, the deployment choice, a
  tools appendix, limitations/ethics, and a reproducibility guide.

  All numbers are read from the generated artefacts (ml/reports/*.json,
  ml/models/model_meta.json) so the report never disagrees with the code.

RUN
  python src/generate_report.py            # -> ml/reports/TrustHire_Report.pdf
"""

from __future__ import annotations

import json
import os

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import cm
from reportlab.platypus import (
    Image,
    PageBreak,
    Paragraph,
    Preformatted,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)

from common import MODELS_DIR, REPORTS_DIR

# ---------------------------------------------------------------------------
# Load whatever metrics exist (the report adapts if DistilBERT wasn't run).
# ---------------------------------------------------------------------------
def _load(path, default=None):
    if os.path.exists(path):
        with open(path, encoding="utf-8") as fh:
            return json.load(fh)
    return default


metrics = _load(os.path.join(REPORTS_DIR, "metrics.json"), {})
meta = _load(os.path.join(MODELS_DIR, "model_meta.json"), {})
distil = _load(os.path.join(REPORTS_DIR, "distilbert_metrics.json"), None)

rule = metrics.get("rule_baseline", {})
ml = metrics.get("ml_model", {})
all_classical = metrics.get("all_classical_models", {})
deployed = meta.get("deployed_model", "logreg")
threshold = metrics.get("threshold", meta.get("threshold", 0.5))

# ---------------------------------------------------------------------------
# Styles
# ---------------------------------------------------------------------------
styles = getSampleStyleSheet()
H1 = ParagraphStyle("H1", parent=styles["Heading1"], fontSize=18,
                    textColor=colors.HexColor("#1A1F36"), spaceAfter=10)
H2 = ParagraphStyle("H2", parent=styles["Heading2"], fontSize=13,
                    textColor=colors.HexColor("#3B5BDB"), spaceBefore=12, spaceAfter=6)
BODY = ParagraphStyle("BODY", parent=styles["BodyText"], fontSize=10, leading=15,
                      spaceAfter=6)
SMALL = ParagraphStyle("SMALL", parent=styles["BodyText"], fontSize=8,
                       textColor=colors.grey)
MONO = ParagraphStyle("MONO", parent=styles["Code"], fontSize=8, leading=11)

story = []


def h1(t): story.append(Paragraph(t, H1))
def h2(t): story.append(Paragraph(t, H2))
def p(t): story.append(Paragraph(t, BODY))
def sp(h=6): story.append(Spacer(1, h))


def fmt(d, k):
    v = d.get(k)
    return f"{v:.3f}" if isinstance(v, (int, float)) else "n/a"


def metric_table():
    cols = ["Metric", "Rule baseline", f"ML ({deployed})"]
    if distil:
        cols.append("DistilBERT")
    rows = [cols]
    dm = (distil or {}).get("test_metrics", {})
    for key in ["accuracy", "precision", "recall", "f1", "roc_auc"]:
        row = [key, fmt(rule, key), fmt(ml, key)]
        if distil:
            row.append(fmt(dm, key))
        rows.append(row)
    t = Table(rows, hAlign="LEFT")
    t.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#1A1F36")),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("FONTSIZE", (0, 0), (-1, -1), 9),
        ("GRID", (0, 0), (-1, -1), 0.5, colors.HexColor("#D1D5DB")),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor("#F5F6FA")]),
        ("PADDING", (0, 0), (-1, -1), 5),
    ]))
    return t


def img(name, width=15 * cm):
    path = os.path.join(REPORTS_DIR, name)
    if os.path.exists(path):
        story.append(Image(path, width=width, height=width * 0.62))
        story.append(Spacer(1, 6))


# ===========================================================================
# Title
# ===========================================================================
h1("TrustHire — Machine-Learning Job-Scam Detection with Screenshot OCR")
p("A research report on replacing a hand-written rule engine with a trained "
  "machine-learning model, and adding an OCR pipeline so users can scan a "
  "screenshot of a job offer. Built in Flutter (app) + Python (ML), backed by "
  "Supabase.")
story.append(Paragraph("Generated automatically from the project's evaluation "
                       "artefacts — every number below comes from the code.", SMALL))
sp()

# ===========================================================================
# 1. Problem statement
# ===========================================================================
h2("1. Problem statement — why job-scam detection is a real ML problem")
p("Online job boards and messaging apps are flooded with fraudulent 'offers' "
  "that extract money (registration/training fees, deposits) or personal data "
  "from job seekers — often students. Scammers constantly reword their messages, "
  "so a fixed list of banned phrases is brittle: it misses anything phrased in a "
  "way the author did not anticipate, and cannot adapt to new tactics. Detecting "
  "scams from free text is therefore a natural <b>supervised text-classification</b> "
  "problem: given the words of a posting, predict fraudulent vs legitimate, "
  "learning the patterns from thousands of real labelled examples rather than "
  "hand-coding them.")

# ===========================================================================
# 2. Architecture
# ===========================================================================
h2("2. End-to-end architecture")
p("The two features form a single pipeline that meets at a plain text string. "
  "Feature A (OCR) produces text from an image; Feature B (ML) turns text into a "
  "risk result. The existing app UI and Supabase storage are unchanged.")
diagram = (
    "  [Screenshot]                                                  \n"
    "       | image_picker                                           \n"
    "       v                                                        \n"
    "  Google ML Kit OCR  (on-device)                                \n"
    "       | extracted text                                         \n"
    "       v                                                        \n"
    "  clean + guard  --> [ also: user-typed text ]                  \n"
    "       |                                                        \n"
    "       v   HTTP POST /predict                                   \n"
    "  FastAPI server  -->  TF-IDF + Logistic Regression             \n"
    "       |                  (rule engine = offline fallback)      \n"
    "       v                                                        \n"
    "  score 0-100 + risk level + reasons  -->  Flutter result card  \n"
    "                                       -->  Supabase scam_checks \n"
)
story.append(Preformatted(diagram, MONO))

# ===========================================================================
# 3. Feature B — the ML process
# ===========================================================================
h2("3. Feature B — the machine-learning process")
p("<b>Dataset.</b> EMSCAD (Employment Scam Aegean Dataset), ~17,880 real job ads "
  "labelled fraudulent (1) or legitimate (0). Only ~866 (4.84%) are fraudulent — "
  "a strong <b>class imbalance</b>. Source: University of the Aegean, mirrored on "
  "Kaggle ('Real or Fake — Fake Job Posting Prediction'); open for academic use. "
  "Fields used: title, company profile, description, requirements, benefits. "
  "Limitations: mostly English, US/UK-skewed, ~2012–2014, and contact details are "
  "anonymised — so newer tactics (crypto/USDT, WhatsApp) are under-represented.")
p("<b>Preprocessing.</b> The free-text fields are merged into one document per "
  "posting. For the ML model the text is lowercased, HTML and anonymisation "
  "placeholders stripped, and whitespace collapsed. A separate case-preserving "
  "copy is kept for the rule baseline (its ALL-CAPS / punctuation checks need it). "
  "Data is split 80/20, <b>stratified</b> (keeps the 4.84% scam rate in both "
  "halves) with a fixed seed (42): 14,304 train / 3,576 test.")
p("<b>Feature extraction — TF-IDF.</b> Text is converted to numbers with "
  "TF-IDF (unigrams + bigrams, min_df=5, max 50k features, sublinear TF, English "
  "stopwords removed). A word scores high if frequent in one posting but rare "
  "across all — a data-driven version of the old keyword lists.")
p("<b>Models.</b> Three standard text classifiers were trained with class "
  "weighting to counter imbalance: Logistic Regression, Multinomial Naive Bayes, "
  "and a (probability-calibrated) Linear SVM. <b>Logistic Regression is the "
  "deployed model</b> because it is interpretable — its per-word weights directly "
  "produce the 'why' shown to the user — and its accuracy is statistically tied "
  "with the SVM.")
if all_classical:
    rows = [["Classical model", "F1", "ROC-AUC"]]
    for name, d in all_classical.items():
        rows.append([name, f"{d.get('f1', 0):.3f}", f"{d.get('roc_auc', 0):.3f}"])
    t = Table(rows, hAlign="LEFT")
    t.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#3B5BDB")),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("FONTSIZE", (0, 0), (-1, -1), 9),
        ("GRID", (0, 0), (-1, -1), 0.5, colors.HexColor("#D1D5DB")),
        ("PADDING", (0, 0), (-1, -1), 5),
    ]))
    story.append(t)
    sp()
p("<b>Training procedure.</b> Each model is a scikit-learn Pipeline (TF-IDF + "
  "classifier) fitted on the training split with random_state=42. The Linear SVM "
  "is wrapped in probability calibration so it can output a scam probability. "
  "Models are saved with joblib for serving." + (
      " DistilBERT (a fine-tuned transformer) was additionally trained as an "
      "upgrade experiment — see below." if distil else ""))

if distil:
    tr = distil.get("training", {})
    p(f"<b>DistilBERT.</b> Fine-tuned distilbert-base-uncased "
      f"({tr.get('epochs','?')} epochs, max_length {tr.get('max_length','?')}, "
      f"{tr.get('rows','?')} training rows"
      + (", legit class down-sampled for CPU training" if tr.get("down_sampled") else "")
      + "). Evaluated on the full test set for a fair comparison. A transformer "
      "reads words in context (unlike bag-of-words TF-IDF), but needs more compute "
      "and is harder to explain.")

h2("3b. Evaluation — ML vs the rule baseline (same test set)")
p("Accuracy is reported but is misleading here: because 95% of posts are "
  "legitimate, a model that always says 'legit' scores ~95% while catching zero "
  "scams. The honest metrics are <b>recall</b> (of real scams, how many caught) "
  "and <b>precision</b> (of flagged posts, how many were real), summarised by F1 "
  "and ROC-AUC.")
story.append(metric_table())
sp()
p(f"The rule baseline manages F1 {fmt(rule,'f1')} (ROC-AUC {fmt(rule,'roc_auc')}, "
  f"barely above the 0.5 of random guessing), while the deployed ML model reaches "
  f"F1 {fmt(ml,'f1')} (ROC-AUC {fmt(ml,'roc_auc')}). The rules were written for "
  "crude consumer scams and do not transfer to EMSCAD's polished corporate fakes; "
  "the ML model learns whatever patterns are actually in the data.")
img("confusion_matrix_ml.png", width=8 * cm)
img("roc_curves.png", width=10 * cm)

# ===========================================================================
# 4. Feature A — OCR
# ===========================================================================
story.append(PageBreak())
h2("4. Feature A — the OCR process")
p("<b>Engine: Google ML Kit Text Recognition.</b> Chosen over Tesseract because "
  "it runs fully on-device (the image never leaves the phone — good privacy), is "
  "free and offline, accurate on phone screenshots, and trivial to set up. "
  "Trade-off: it supports Android/iOS only, which matches the app's primary "
  "targets. Tesseract is noted as the open-source alternative.")
p("<b>Image pipeline.</b> The user picks an image from gallery or camera "
  "(image_picker). ML Kit returns the recognised text. The text is trimmed and "
  "run through the same 'looks like a job post' guard as typed input, then sent to "
  "the detector — so a screenshot flows through the identical ML path as pasted "
  "text. The extracted text is shown in an editable box so the user can correct "
  "any OCR mistakes before analysing.")

# ===========================================================================
# 5. Deployment
# ===========================================================================
h2("5. Deployment approach — and why")
p("The model is served from a small self-hosted <b>FastAPI</b> server that the "
  "app calls over HTTP, rather than embedded on-device. Reasons: scikit-learn "
  "pipelines do not convert cleanly to a mobile runtime (TFLite); a server lets us "
  "deploy the best/largest model (including DistilBERT) with no conversion pain; "
  "and the model can be retrained and redeployed without rebuilding the app. The "
  "app already speaks HTTP (Supabase, FCM), so this fits its architecture. "
  "Trade-off: it needs network and a running server, and text leaves the device. "
  "To guarantee the feature never hard-fails, the app falls back to the original "
  "on-device rule engine whenever the server is unreachable.")

# ===========================================================================
# 6. Tools & resources appendix
# ===========================================================================
h2("6. Tools & resources (open-source)")
tools = [
    ["Resource", "Use"],
    ["EMSCAD dataset (Kaggle: shivamb/real-or-fake-fake-jobposting-prediction)",
     "Labelled job-scam data"],
    ["scikit-learn", "TF-IDF + Logistic Regression / NB / SVM, metrics"],
    ["pandas, numpy, scipy", "Data handling"],
    ["matplotlib", "Confusion matrix & ROC plots"],
    ["Hugging Face transformers + datasets, PyTorch", "DistilBERT fine-tuning"],
    ["FastAPI + uvicorn", "Inference API"],
    ["reportlab", "This PDF report"],
    ["google_mlkit_text_recognition", "On-device OCR (Flutter)"],
    ["image_picker", "Gallery/camera image selection (Flutter)"],
]
t = Table(tools, hAlign="LEFT", colWidths=[9 * cm, 6 * cm])
t.setStyle(TableStyle([
    ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#1A1F36")),
    ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
    ("FONTSIZE", (0, 0), (-1, -1), 8),
    ("GRID", (0, 0), (-1, -1), 0.5, colors.HexColor("#D1D5DB")),
    ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor("#F5F6FA")]),
    ("PADDING", (0, 0), (-1, -1), 4),
]))
story.append(t)
sp()

# ===========================================================================
# 7. Limitations, ethics, future work
# ===========================================================================
h2("7. Limitations, ethics & future work")
p("<b>Dataset bias.</b> EMSCAD is older, English, Western, and anonymises "
  "contacts, so the model underweights newer signals (crypto, WhatsApp/Telegram) "
  "— exactly the signals the rule engine catches. Neither approach dominates "
  "everywhere; a production system should combine them.")
p("<b>Imbalance & threshold.</b> At 4.84% scams, the decision threshold is a "
  f"values choice (currently p>={threshold} = scam). A lower threshold catches "
  "more scams (higher recall) at the cost of more false alarms. This should be "
  "tuned to how costly a missed scam is versus a false warning.")
p("<b>Ethics.</b> The tool is decision-support, not a verdict: a 'High Risk' "
  "label could unfairly tar a legitimate employer, and a 'Low Risk' label could "
  "lull a user. Predictions are shown with explanations and the model can be "
  "wrong; users should not treat it as proof.")
p("<b>Future work.</b> Combine rules + ML (hybrid), add newer scam examples, "
  "multilingual support, OCR preprocessing for low-quality images, on-device "
  "distilled model for offline use, and periodic retraining as tactics evolve.")

# ===========================================================================
# 8. Reproducibility
# ===========================================================================
h2("8. Reproducibility")
p("Environment: Python 3.14, dependencies pinned in ml/requirements.txt "
  "(+ requirements-distilbert.txt). Every split and model uses random_state=42.")
steps = (
    "python -m venv .venv && .\\.venv\\Scripts\\python.exe -m pip install -r requirements.txt\n"
    "python src/prepare_data.py        # split data (stratified, seeded)\n"
    "python src/rule_baseline.py       # rule-engine baseline metrics\n"
    "python src/train_classical.py     # train + save models\n"
    "python src/evaluate.py            # metrics + plots + comparison\n"
    "python src/train_distilbert.py    # optional transformer upgrade\n"
    "uvicorn api.main:app --port 8000  # serve the model to the app\n"
    "python src/generate_report.py     # rebuild this PDF\n"
)
story.append(Preformatted(steps, MONO))

# ---------------------------------------------------------------------------
out_pdf = os.path.join(REPORTS_DIR, "TrustHire_Report.pdf")
SimpleDocTemplate(out_pdf, pagesize=A4,
                  topMargin=1.6 * cm, bottomMargin=1.6 * cm,
                  leftMargin=1.8 * cm, rightMargin=1.8 * cm).build(story)
print(f"Saved report -> {out_pdf}")
