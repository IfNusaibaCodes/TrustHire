/// Rule-based analysis that decides whether a job post looks fake or real.
class ScamResult {
  final int score; // 0–100, higher = safer
  final String riskLevel; // Low / Medium / High Risk
  final List<String> issues;
  final List<String> positives;

  const ScamResult(this.score, this.riskLevel, this.issues, this.positives);
}

class ScamAnalyzer {
  static ScamResult analyze(String input) {
    final text = input.toLowerCase();
    final issues = <String>[];
    final positives = <String>[];
    int score = 100;

    void flag(bool match, String issue, int penalty) {
      if (match) {
        issues.add(issue);
        score -= penalty;
      }
    }

    void sign(bool match, String label) {
      if (match) positives.add(label);
    }

    flag(text.contains('urgent'), 'Urgent hiring pressure', 20);
    flag(
      text.contains('payment') ||
          text.contains('registration fee') ||
          text.contains('deposit'),
      'Requests upfront payment',
      30,
    );
    flag(
      text.contains('gmail') ||
          text.contains('yahoo') ||
          text.contains('hotmail'),
      'Uses free email domain',
      15,
    );
    flag(
      RegExp(r'salary\s*5000').hasMatch(text) ||
          text.contains('guaranteed income'),
      'Unrealistic salary promise',
      20,
    );
    flag(
      text.contains('whatsapp') || text.contains('telegram'),
      'Contact via unofficial channel',
      15,
    );

    sign(text.contains('website'), 'Has company website');
    sign(text.contains('experience'), 'Proper job description');
    sign(text.contains('interview'), 'Mentions interview process');

    score = score.clamp(0, 100);
    final risk = score >= 70
        ? 'Low Risk'
        : score >= 40
            ? 'Medium Risk'
            : 'High Risk';

    return ScamResult(score, risk, issues, positives);
  }
}
