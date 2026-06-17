class NotificationModel {
  final String  id;
  final String  type;
  final String  title;
  final String  body;
  final String? sentBy;
  final String? targetRole;
  final String? targetUniversity;
  final String? targetStudyYear;
  final DateTime createdAt;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.sentBy,
    this.targetRole,
    this.targetUniversity,
    this.targetStudyYear,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromMap(
    Map<String, dynamic> map, {
    required bool isRead,
  }) {
    return NotificationModel(
      id:               map['id']                as String,
      type:             map['type']              as String? ?? 'general',
      title:            map['title']             as String,
      body:             map['body']              as String,
      sentBy:           map['sent_by']           as String?,
      targetRole:       map['target_role']       as String?,
      targetUniversity: map['target_university'] as String?,
      targetStudyYear:  map['target_study_year'] as String?,
      createdAt:        DateTime.parse(map['created_at'] as String).toLocal(),
      isRead:           isRead,
    );
  }

  bool matchesAudience({
    String? userRole,
    String? university,
    String? studyYear,
  }) {
    if (targetRole != null && targetRole != userRole) return false;
    if (targetUniversity != null && targetUniversity != university) return false;
    if (targetStudyYear != null && targetStudyYear != studyYear) return false;
    return true;
  }
}
