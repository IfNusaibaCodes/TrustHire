class ScamCheckRecord {
  final String? id;
  final String userId;
  final String inputText;
  final int score;
  final String riskLevel;
  final List<String> issues;
  final List<String> positives;
  final DateTime? createdAt;

  const ScamCheckRecord({
    this.id,
    required this.userId,
    required this.inputText,
    required this.score,
    required this.riskLevel,
    required this.issues,
    required this.positives,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'input_text': inputText,
        'score': score,
        'risk_level': riskLevel,
        'issues': issues,
        'positives': positives,
      };

  factory ScamCheckRecord.fromJson(Map<String, dynamic> json) => ScamCheckRecord(
        id: json['id'] as String?,
        userId: json['user_id'] as String,
        inputText: json['input_text'] as String,
        score: json['score'] as int,
        riskLevel: json['risk_level'] as String,
        issues: (json['issues'] as List<dynamic>? ?? []).cast<String>(),
        positives: (json['positives'] as List<dynamic>? ?? []).cast<String>(),
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
      );
}
