import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Authentication/Services/auth_service.dart';
import '../../Model/scam_check_model.dart';

class ScamCheckRepository {
  final client = Supabase.instance.client;
  final authService = AuthService();

  String _getRequiredUid() {
    final uid = authService.getCurrentUid();
    if (uid == null) {
      throw Exception("User is not logged in.");
    }
    return uid;
  }

  Future<ScamCheckRecord> saveResult({
    required String inputText,
    required int score,
    required String riskLevel,
    required List<String> issues,
    required List<String> positives,
  }) async {
    final uid = _getRequiredUid();
    final record = ScamCheckRecord(
      userId: uid,
      inputText: inputText,
      score: score,
      riskLevel: riskLevel,
      issues: issues,
      positives: positives,
    );

    final inserted = await client
        .from('scam_checks')
        .insert(record.toJson())
        .select()
        .single();
    return ScamCheckRecord.fromJson(inserted);
  }

  Future<List<ScamCheckRecord>> fetchHistory() async {
    final uid = _getRequiredUid();
    final response = await client
        .from('scam_checks')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((row) => ScamCheckRecord.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteRecord(String id) async {
    final uid = _getRequiredUid();
    await client.from('scam_checks').delete().eq('id', id).eq('user_id', uid);
  }
}
