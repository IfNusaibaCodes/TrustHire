import 'package:supabase_flutter/supabase_flutter.dart';
import 'notification_model.dart';

class NotificationService {
  static final _client = Supabase.instance.client;

  static Future<List<NotificationModel>> fetchNotifications({
    required String uid,
    String? userRole,
    String? university,
    String? studyYear,
  }) async {
    final results = await Future.wait([
      _client.from('notifications').select().order('created_at', ascending: false),
      _client.from('notification_reads').select('notification_id').eq('user_id', uid),
    ]);

    final notifRows = results[0] as List;
    final readRows  = results[1] as List;
    final readIds   = readRows.map((e) => e['notification_id'] as String).toSet();

    return notifRows
        .map((e) => NotificationModel.fromMap(e, isRead: readIds.contains(e['id'] as String)))
        .where((n) => n.matchesAudience(
          userRole:   userRole,
          university: university,
          studyYear:  studyYear,
        ))
        .toList();
  }

  static Future<void> markAsRead(String userId, String notifId) async {
    await _client.from('notification_reads').upsert(
      {'user_id': userId, 'notification_id': notifId},
      onConflict: 'user_id, notification_id',
    );
  }

  static Future<void> markAllAsRead(String userId, List<String> ids) async {
    if (ids.isEmpty) return;
    await _client.from('notification_reads').upsert(
      ids.map((id) => {'user_id': userId, 'notification_id': id}).toList(),
      onConflict: 'user_id, notification_id',
    );
  }

  static RealtimeChannel subscribeToInserts(void Function() onInsert) {
    return _client
        .channel('notifications_feed')
        .onPostgresChanges(
          event:    PostgresChangeEvent.insert,
          schema:   'public',
          table:    'notifications',
          callback: (_) => onInsert(),
        )
        .subscribe();
  }

  static Future<void> unsubscribe(RealtimeChannel channel) async {
    await _client.removeChannel(channel);
  }

  static Future<void> createBroadcast({
    required String title,
    required String body,
    String  type              = 'general',
    String? targetRole,
    String? targetUniversity,
    String? targetStudyYear,
  }) async {
    final uid = _client.auth.currentUser?.id;
    await _client.from('notifications').insert({
      'type':  type,
      'title': title,
      'body':  body,
      if (uid != null)              'sent_by':           uid,
      if (targetRole != null)       'target_role':       targetRole,
      if (targetUniversity != null) 'target_university': targetUniversity,
      if (targetStudyYear != null)  'target_study_year': targetStudyYear,
    });
  }
}
