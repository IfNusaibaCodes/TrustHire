class ScamResult {
  final int score;
  final String riskLevel;
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

    bool has(List<String> words) => words.any(text.contains);

    final wordCount =
        text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final looksLikeJobPost = has([
      'job',
      'hiring',
      'salary',
      'position',
      'vacancy',
      'apply',
      'work',
      'employ',
      'candidate',
      'recruit',
      'company',
      'role',
      'opportunity',
    ]);

    if (text.trim().isEmpty) {
      return const ScamResult(0, 'Unknown', ['No text provided'], []);
    }

    if (wordCount < 8 || !looksLikeJobPost) {
      return const ScamResult(
        0,
        'Not Enough Info',
        [
          "This doesn't look like a job post.",
          'Paste the full job offer, email or message to get an accurate result.',
        ],
        [],
      );
    }

    flag(has(['urgent', 'immediate', 'act now', 'limited slots', 'hurry']),
        'Urgent hiring pressure', 15);
    flag(has(['apply now', 'don\'t miss', 'last chance']),
        'High-pressure call to action', 10);

    flag(
      has([
        'payment',
        'registration fee',
        'deposit',
        'processing fee',
        'training fee',
        'security deposit',
        'pay to',
        'send money',
        'advance payment',
      ]),
      'Requests upfront payment',
      35,
    );
    flag(
      has(['gift card', 'bitcoin', 'crypto', 'usdt', 'wire transfer', 'western union']),
      'Asks for untraceable payment method',
      30,
    );

    flag(
      has([
        'bank account',
        'credit card',
        'national id',
        'ssn',
        'social security',
        'passport number',
        'pin number',
        'otp',
        'password',
      ]),
      'Requests sensitive personal/financial data',
      30,
    );

    flag(has(['gmail', 'yahoo', 'hotmail', 'outlook.com']),
        'Uses free email domain', 12);
    flag(has(['whatsapp', 'telegram', 'signal', 'wechat']),
        'Contact via unofficial messaging channel', 12);

    flag(
      has([
            'guaranteed income',
            'no experience needed',
            'earn from home',
            'work from home guaranteed',
            'easy money',
            'become rich',
            'unlimited earning',
          ]) ||
          RegExp(r'\$?\d{4,}\s*(per day|/day|a day|per week|/week)')
              .hasMatch(text),
      'Unrealistic income promise',
      20,
    );
    flag(
      RegExp(r'(salary|pay|earn).{0,15}\$?\s?\d{5,}').hasMatch(text),
      'Salary looks too good to be true',
      15,
    );

    flag(
      RegExp(r'(congratulation|you have been selected|you are shortlisted)')
              .hasMatch(text) &&
          !has(['interview', 'cv', 'resume']),
      'Selected without any interview/application',
      20,
    );
    flag(
      RegExp(r'[A-Z]{6,}').hasMatch(input),
      'Excessive use of capital letters',
      8,
    );
    flag(
      (RegExp(r'[!]{2,}').hasMatch(text)) ||
          RegExp(r'\$\$+').hasMatch(text),
      'Spammy punctuation/symbols',
      8,
    );

    sign(has(['website', '.com', 'www.', 'http']), 'Includes a company website');
    sign(has(['experience', 'qualification', 'requirements', 'responsibilities']),
        'Proper job description');
    sign(has(['interview', 'cv', 'resume', 'application']),
        'Mentions a real application/interview process');
    sign(has(['ltd', 'limited', 'inc', 'corporation', 'pvt']),
        'Names a registered company');
    sign(has(['office', 'address', 'location']), 'Provides a physical location');

    score = score.clamp(0, 100);

    if (issues.isEmpty && positives.isEmpty) {
      issues.add('Not enough detail to verify legitimacy');
      score = 60;
    }

    final risk = score >= 75
        ? 'Low Risk'
        : score >= 45
            ? 'Medium Risk'
            : 'High Risk';

    return ScamResult(score, risk, issues, positives);
  }
}
