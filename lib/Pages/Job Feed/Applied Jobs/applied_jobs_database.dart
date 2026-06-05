import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';
import 'package:trust_hire_app/Model/job_model.dart';

class AppliedJobsService {
  final _client      = Supabase.instance.client;
  final _authService = AuthService();

  String _getUid() {
    final uid = _authService.getCurrentUid();
    if (uid == null) throw Exception("User is not logged in.");
    return uid;
  }

  Future<bool> isApplied(int jobId) async {
    final uid      = _getUid();
    final response = await _client
        .from('applied_jobs')
        .select('id')
        .eq('user_id', uid)
        .eq('job_id', jobId)
        .maybeSingle();
    return response != null;
  }

  Future<List<JobModel>> fetchAppliedJobs() async {
    final uid      = _getUid();
    final response = await _client
        .from('applied_jobs')
        .select('job_id')
        .eq('user_id', uid)
        .order('created_at', ascending: false);

    final jobIds = (response as List).map((e) => e['job_id'] as int).toList();
    if (jobIds.isEmpty) return [];

    final jobsResponse = await _client
        .from('jobs')
        .select()
        .inFilter('id', jobIds);

    return (jobsResponse as List).map((e) => JobModel.fromMap(e)).toList();
  }

  Future<void> markApplied(int jobId) async {
    final uid = _getUid();
    await _client.from('applied_jobs').upsert(
      {'user_id': uid, 'job_id': jobId},
      onConflict: 'user_id, job_id',
    );
    await _updateAppliedCount(1);
  }

  Future<void> removeApplied(int jobId) async {
    final uid = _getUid();
    await _client
        .from('applied_jobs')
        .delete()
        .eq('user_id', uid)
        .eq('job_id', jobId);
    await _updateAppliedCount(-1);
  }

  Future<void> _updateAppliedCount(int delta) async {
    final uid      = _getUid();
    final response = await _client
        .from('profile_stats')
        .select('applied_count')
        .eq('user_id', uid)
        .maybeSingle();

    if (response == null) return;

    final current = (response['applied_count'] as int?) ?? 0;
    final updated = (current + delta).clamp(0, 999999);

    await _client
        .from('profile_stats')
        .update({'applied_count': updated})
        .eq('user_id', uid);
  }
}
