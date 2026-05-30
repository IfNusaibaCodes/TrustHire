import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Authentication/Services/auth_service.dart';
import '../../Model/burnout_model.dart';

class BurnoutRepository {
  final client = Supabase.instance.client;
  final authService = AuthService();

  String _getRequiredUid() {
    final uid = authService.getCurrentUid();
    if (uid == null) {
      throw Exception("User is not logged in.");
    }
    return uid;
  }


  //insert
  Future<void> saveAnswers({
    required List<BurnoutQuestion> questions,
    required Map<int, int> selectedAnswers,
  }) async {
    final rows = <Map<String, dynamic>>[];

    for (int i = 0; i < questions.length; i++) {
      final uid = _getRequiredUid();
      final q = questions[i];
      final int optIndex = selectedAnswers[i]!;
      final String answer = q.options[optIndex].label;

      final record = BurnoutRecord(
        userId: uid,
        questionNumber: q.questionNumber,
        questionText: q.question,
        answer: answer,
      );

      rows.add(record.toJson());
    }

    await client.from('burnout_checks').insert(rows);
  }

  // ── FETCH: load all past check-ins for the current user ──
  Future<List<BurnoutRecord>> fetchHistory() async {
    final uid = _getRequiredUid();
    final response = await client
        .from('burnout_checks')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((row) => BurnoutRecord.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  // ── FETCH: check-ins for a specific date ─────────────────
  Future<List<BurnoutRecord>> fetchByDate(DateTime date) async {
    final uid = _getRequiredUid();
    final from = DateTime(date.year, date.month, date.day);
    final to   = from.add(const Duration(days: 1));

    final response = await client
        .from('burnout_checks')
        .select()
        .eq('user_id', uid)
        .gte('created_at', from.toIso8601String())
        .lt('created_at', to.toIso8601String())
        .order('question_number');

    return (response as List<dynamic>)
        .map((row) => BurnoutRecord.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  // ── DELETE: remove a check-in by id ──────────────────────
  Future<void> deleteRecord(String id) async {
    final uid = _getRequiredUid();
    await client
        .from('burnout_checks')
        .delete()
        .eq('id', uid);
  }
}