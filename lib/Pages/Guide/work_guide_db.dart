import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';

class GuideProgressService {
  final client = Supabase.instance.client;
  final authService = AuthService();

  String _getRequiredUid() {
    final uid = authService.getCurrentUid();
    if (uid == null) {
      throw Exception("User is not logged in.");
    }
    return uid;
  }

  // GET user progress
  Future<Map<String, bool>> fetchProgress() async {
    final uid = _getRequiredUid();
    final data = await client
        .from('user_guide_progress')                                             //from auth service anba
        .select()
        .eq('user_id', uid);

    final Map<String, bool> result = {};

    for (final item in data) {
      result[item['section_key']] = item['is_read'] ?? false;
    }

    return result;
  }

  // TOGGLE READ STATUS
  Future<void> toggle({
    required String sectionKey,
    required bool isRead,
  }) async {
    final uid = _getRequiredUid();
    await client.from('user_guide_progress').upsert({
      'user_id': uid,
      'section_key': sectionKey,
      'is_read': isRead,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}