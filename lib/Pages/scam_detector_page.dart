import 'package:flutter/material.dart';

class ScamDetectorPage extends StatefulWidget {
  const ScamDetectorPage({super.key});

  @override
  State<ScamDetectorPage> createState() =>
      _ScamDetectorPageState();
}

class _ScamDetectorPageState
    extends State<ScamDetectorPage> {

  // ── Color Palette ──────────────────────────
  static const Color bgPage      = Color(0xFFF8FAFC);
  static const Color bgCard      = Color(0xFFFFFFFF);
  static const Color accentGold  = Color(0xFFF59E0B);
  static const Color accentRed   = Color(0xFFEF4444);
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textMuted   = Color(0xFF64748B);
  static const Color cardBorder  = Color(0xFFE2E8F0);
  // ───────────────────────────────────────────

  TextEditingController textController =
  TextEditingController();

  String resultText = "";
  String riskLevel = "";
  List<String> detectedIssues = [];
  List<String> positiveSigns = [];
  bool isLoading = false;

  void analyzeScam() async {
    setState(() { isLoading = true; });

    await Future.delayed(const Duration(seconds: 2));

    String text = textController.text.toLowerCase();
    detectedIssues.clear();
    positiveSigns.clear();
    int score = 100;

    if (text.contains("urgent")) {
      detectedIssues.add("Urgent hiring pressure");
      score -= 20;
    }
    if (text.contains("payment")) {
      detectedIssues.add("Requests payment");
      score -= 30;
    }
    if (text.contains("gmail")) {
      detectedIssues.add("Uses free email domain");
      score -= 15;
    }
    if (text.contains("salary 5000")) {
      detectedIssues.add("Unrealistic salary promise");
      score -= 20;
    }
    if (text.contains("website")) {
      positiveSigns.add("Has company website");
    }
    if (text.contains("experience")) {
      positiveSigns.add("Proper job description");
    }

    if (score >= 70) {
      riskLevel = "Low Risk";
    } else if (score >= 40) {
      riskLevel = "Medium Risk";
    } else {
      riskLevel = "High Risk";
    }

    resultText = "$score% Safe";
    setState(() { isLoading = false; });
  }

  Color get riskColor {
    if (riskLevel == "High Risk") return accentRed;
    if (riskLevel == "Medium Risk") return accentOrange;
    return accentGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        backgroundColor: bgCard,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Scam Detector",
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: cardBorder, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ──
            const Text(
              "Check Job Safety",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Paste a job post, URL, or screenshot to detect scams.",
              style: TextStyle(
                fontSize: 14,
                color: textMuted,
              ),
            ),

            const SizedBox(height: 24),

            // ── Job Description Card ──
            _sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(Icons.description_outlined, "Job Description"),
                  const SizedBox(height: 12),
                  TextField(
                    controller: textController,
                    maxLines: 7,
                    style: const TextStyle(
                      color: textPrimary,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: "Paste job post, email, or message...",
                      hintStyle: const TextStyle(color: textMuted),
                      filled: true,
                      fillColor: bgPage,
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: accentGold, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Upload screenshot button
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.image_outlined, size: 20, color: accentGold),
                      label: const Text(
                        "Upload Screenshot",
                        style: TextStyle(
                          color: accentGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: accentGold, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── URL Card ──
            _sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(Icons.link_outlined, "Job URL"),
                  const SizedBox(height: 12),
                  TextField(
                    style: const TextStyle(color: textPrimary, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "Paste job post link...",
                      hintStyle: const TextStyle(color: textMuted),
                      filled: true,
                      fillColor: bgPage,
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: accentGold, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Analyze Button ──
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: analyzeScam,
                icon: const Icon(Icons.search, color: Colors.white, size: 22),
                label: const Text(
                  "Analyze Now",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGold,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Loading ──
            if (isLoading)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: accentGold,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Analyzing job safety...",
                      style: TextStyle(
                        fontSize: 15,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ),

            // ── Results ──
            if (resultText.isNotEmpty && !isLoading) ...[

              // Result summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: riskColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        riskLevel == "High Risk"
                            ? Icons.dangerous_outlined
                            : riskLevel == "Medium Risk"
                            ? Icons.warning_amber_outlined
                            : Icons.verified_outlined,
                        color: riskColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resultText,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: riskColor,
                          ),
                        ),
                        Text(
                          riskLevel,
                          style: TextStyle(
                            fontSize: 15,
                            color: riskColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Detected Issues card
              if (detectedIssues.isNotEmpty)
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel(Icons.warning_amber_outlined, "Detected Issues"),
                      const SizedBox(height: 10),
                      ...detectedIssues.map(
                            (issue) => _resultTile(
                          icon: Icons.cancel_outlined,
                          iconColor: accentRed,
                          bgColor: accentRed.withOpacity(0.08),
                          text: issue,
                          textColor: const Color(0xFF7F1D1D),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 14),

              // Positive Signs card
              if (positiveSigns.isNotEmpty)
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel(Icons.check_circle_outline, "Positive Signs"),
                      const SizedBox(height: 10),
                      ...positiveSigns.map(
                            (sign) => _resultTile(
                          icon: Icons.check_circle_outline,
                          iconColor: accentGreen,
                          bgColor: accentGreen.withOpacity(0.08),
                          text: sign,
                          textColor: const Color(0xFF14532D),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
            ],

          ],
        ),
      ),
    );
  }

  // ── Reusable white card wrapper ──
  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // ── Section label with icon ──
  Widget _sectionLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: accentGold),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
      ],
    );
  }

  // ── Result tile (issues / positive signs) ──
  Widget _resultTile({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String text,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}