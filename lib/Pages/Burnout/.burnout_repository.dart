// ============================================================
//  FILE: lib/repositories/burnout_repository.dart
// ============================================================
//  Burnout Check — Database / Supabase Layer
//
//  ── SUPABASE TABLE (run once in SQL Editor) ───────────────
//  create table burnout_checks (
//    id               uuid default gen_random_uuid() primary key,
//    user_id          uuid references auth.users(id),
//    answer           text not null,
//    question_number  int not null,
//    question_text    text not null,
//    created_at       timestamp default now()
//  );
//
//  ── DEPENDENCY ────────────────────────────────────────────
//  pubspec.yaml: supabase_flutter: ^2.0.0
//  main.dart:    Supabase.initialize(url: '...', anonKey: '...')
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Model/burnout_model.dart';
import '../models/burnout_model.dart';

class BurnoutRepository {
  BurnoutRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  // ── Current user id (fallback for local testing) ─────────
  String get _userId =>
      _client.auth.currentUser?.id ?? 'test-user-123';

  // ── INSERT: save all answers in one batch call ────────────
  /// Builds a list of [BurnoutRecord] from the answers map
  /// (pageIndex → optionIndex) and inserts them all at once.
  Future<void> saveAnswers({
    required List<BurnoutQuestion> questions,
    required Map<int, int> selectedAnswers,
  }) async {
    final rows = <Map<String, dynamic>>[];

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final int optIndex = selectedAnswers[i]!;
      final String answer = q.options[optIndex].label;

      final record = BurnoutRecord(
        userId: _userId,
        questionNumber: q.questionNumber,
        questionText: q.question,
        answer: answer,
      );

      rows.add(record.toJson());
    }

    await _client.from('burnout_checks').insert(rows);
  }

  // ── FETCH: load all past check-ins for the current user ──
  Future<List<BurnoutRecord>> fetchHistory() async {
    final response = await _client
        .from('burnout_checks')
        .select()
        .eq('user_id', _userId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((row) => BurnoutRecord.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  // ── FETCH: check-ins for a specific date ─────────────────
  Future<List<BurnoutRecord>> fetchByDate(DateTime date) async {
    final from = DateTime(date.year, date.month, date.day);
    final to   = from.add(const Duration(days: 1));

    final response = await _client
        .from('burnout_checks')
        .select()
        .eq('user_id', _userId)
        .gte('created_at', from.toIso8601String())
        .lt('created_at', to.toIso8601String())
        .order('question_number');

    return (response as List<dynamic>)
        .map((row) => BurnoutRecord.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  // ── DELETE: remove a check-in by id ──────────────────────
  Future<void> deleteRecord(String id) async {
    await _client
        .from('burnout_checks')
        .delete()
        .eq('id', id);
  }
}