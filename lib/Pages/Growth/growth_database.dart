import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';
import 'package:trust_hire_app/Model/profile_models.dart';
import 'package:trust_hire_app/Model/job_model.dart';

class GrowthDatabase {
  static final _client      = Supabase.instance.client;
  static final _authService = AuthService();

  static String _uid() {
    final uid = _authService.getCurrentUid();
    if (uid == null) throw Exception('Not logged in');
    return uid;
  }

  static Future<ProfileStats> loadStats() async {
    final uid      = _uid();
    final response = await _client
        .from('profile_stats')
        .select()
        .eq('user_id', uid)
        .maybeSingle();
    if (response == null) return const ProfileStats();
    return ProfileStats.fromMap(response);
  }

  static Future<int> loadStreak() async {
    final uid      = _uid();
    final response = await _client
        .from('planner_streaks')
        .select('streak_days')
        .eq('user_id', uid)
        .maybeSingle();
    return (response?['streak_days'] as int?) ?? 0;
  }

  static Future<ProfileModel> loadProfile() async {
    final uid      = _uid();
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();
    if (response == null) return const ProfileModel();
    return ProfileModel.fromMap(response);
  }

  static Future<int> loadSkillCount() async {
    final uid      = _uid();
    final response = await _client
        .from('skills')
        .select('id')
        .eq('user_id', uid);
    return (response as List).length;
  }

  static Future<int> loadExperienceCount() async {
    final uid      = _uid();
    final response = await _client
        .from('experiences')
        .select('id')
        .eq('user_id', uid);
    return (response as List).length;
  }

  static Future<List<JobModel>> loadRecentApplied() async {
    final uid         = _uid();
    final appliedRows = await _client
        .from('applied_jobs')
        .select('job_id')
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .limit(3);

    final jobIds = (appliedRows as List).map((e) => e['job_id'] as int).toList();
    if (jobIds.isEmpty) return [];

    final jobs = await _client
        .from('jobs')
        .select()
        .inFilter('id', jobIds);
    return (jobs as List).map((e) => JobModel.fromMap(e)).toList();
  }

  static Future<int> loadAppliedThisWeek() async {
    final uid    = _uid();
    final now    = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final from   = DateTime(monday.year, monday.month, monday.day).toIso8601String();

    final response = await _client
        .from('applied_jobs')
        .select('id')
        .eq('user_id', uid)
        .gte('created_at', from);
    return (response as List).length;
  }

  static Future<List<int>> loadWeeklyActivity() async {
    final uid    = _uid();
    final now    = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final from   = DateTime(monday.year, monday.month, monday.day);

    final response = await _client
        .from('applied_jobs')
        .select('created_at')
        .eq('user_id', uid)
        .gte('created_at', from.toIso8601String());

    final counts = List.filled(7, 0);
    for (final row in response as List) {
      final date = DateTime.tryParse((row['created_at'] as String?) ?? '');
      if (date != null) {
        final i = date.toLocal().weekday - 1;
        if (i >= 0 && i < 7) counts[i]++;
      }
    }
    return counts;
  }
}
