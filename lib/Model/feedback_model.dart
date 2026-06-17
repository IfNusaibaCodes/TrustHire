class FeedbackModel {
  final String    id;
  final String?   userId;
  final String    feature;
  final String    rating;
  final String?   problem;
  final String?   suggestion;
  final String?   email;
  final String?   phone;
  final DateTime? createdAt;

  const FeedbackModel({
    required this.id,
    this.userId,
    required this.feature,
    required this.rating,
    this.problem,
    this.suggestion,
    this.email,
    this.phone,
    this.createdAt,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id:         map['id']         as String,
      userId:     map['user_id']    as String?,
      feature:    map['feature']    as String,
      rating:     map['rating']     as String,
      problem:    map['problem']    as String?,
      suggestion: map['suggestion'] as String?,
      email:      map['email']      as String?,
      phone:      map['phone']      as String?,
      createdAt:  map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toInsertMap() {
    final map = <String, dynamic>{
      'feature': feature,
      'rating':  rating,
    };
    if (userId     != null) map['user_id']    = userId;
    if (problem    != null && problem!.isNotEmpty)    map['problem']    = problem;
    if (suggestion != null && suggestion!.isNotEmpty) map['suggestion'] = suggestion;
    if (email      != null && email!.isNotEmpty)      map['email']      = email;
    if (phone      != null && phone!.isNotEmpty)      map['phone']      = phone;
    return map;
  }
}
