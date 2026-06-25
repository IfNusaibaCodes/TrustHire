import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';
import 'package:trust_hire_app/Model/job_model.dart';


class SavedJobsService {
  final _client      = Supabase.instance.client;
  final _authService = AuthService();

  String _getUid() {
    final uid = _authService.getCurrentUid();
    if (uid == null) throw Exception("User is not logged in.");
    return uid;
  }

  Future<Set<int>> fetchSavedJobIds() async {
    final uid      = _getUid();
    final response = await _client
        .from('saved_jobs')
        .select('job_id')
        .eq('user_id', uid);
    return (response as List).map((e) => e['job_id'] as int).toSet();
  }


  Future<List<JobModel>> fetchSavedJobs() async {
    final uid      = _getUid();
    final response = await _client
        .from('saved_jobs')
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

  Future<void> saveJob(int jobId) async {
    final uid = _getUid();
    await _client.from('saved_jobs').upsert(
      {'user_id': uid, 'job_id': jobId},
      onConflict: 'user_id, job_id',
    );

    await _updateSavedCount(1);
  }

  Future<void> unsaveJob(int jobId) async {
    final uid = _getUid();
    await _client
        .from('saved_jobs')
        .delete()
        .eq('user_id', uid)
        .eq('job_id', jobId);

    await _updateSavedCount(-1);
  }

  Future<bool> toggleSave(int jobId, bool currentlySaved) async {
    if (currentlySaved) {
      await unsaveJob(jobId);
      return false;
    } else {
      await saveJob(jobId);
      return true;
    }
  }



  Future<void> _updateSavedCount(int delta) async {
    final uid = _getUid();


    final response = await _client
        .from('profile_stats')
        .select('saved_count')
        .eq('user_id', uid)
        .maybeSingle();

    if (response == null) return;

    final current = (response['saved_count'] as int?) ?? 0;
    final updated = (current + delta).clamp(0, 999999);

    await _client
        .from('profile_stats')
        .update({'saved_count': updated})
        .eq('user_id', uid);
  }
}