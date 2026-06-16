import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';

/// Displays the outcome of a scam analysis: a safety score + risk level header,
/// followed by detected issues and positive signs. Colour adapts to [riskLevel]
/// ('High Risk' / 'Medium Risk' / anything else = low risk).
///
/// Example:
/// ```dart
/// ScamResultCard(
///   score: 70,
///   riskLevel: 'Medium Risk',
///   issues: ['Requests upfront payment'],
///   positives: ['Has company website'],
/// )
/// ```
class ScamResultCard extends StatelessWidget {
  final int score;
  final String riskLevel;
  final List<String> issues;
  final List<String> positives;

  const ScamResultCard({
    super.key,
    required this.score,
    required this.riskLevel,
    required this.issues,
    required this.positives,
  });

  @override
  Widget build(BuildContext context) {
    final highRisk = riskLevel == 'High Risk';
    final mediumRisk = riskLevel == 'Medium Risk';
    final color = highRisk
        ? TColors.appError
        : mediumRisk
            ? TColors.appAmber
            : TColors.appSuccess;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  highRisk
                      ? Icons.dangerous_rounded
                      : mediumRisk
                          ? Icons.warning_amber_rounded
                          : Icons.verified_rounded,
                  color: color,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$score% Safe',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800, color: color)),
                  Text(riskLevel,
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600, color: color)),
                ],
              ),
            ],
          ),
          for (final issue in issues)
            _line(Icons.cancel_rounded, TColors.appError, issue),
          for (final sign in positives)
            _line(Icons.check_circle_rounded, TColors.appSuccess, sign),
        ],
      ),
    );
  }

  Widget _line(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 13, color: Color(0xFF374151))),
          ),
        ],
      ),
    );
  }
}
