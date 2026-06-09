import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Model/job_model.dart';

class JobsDatabaseService {
  static final _client = Supabase.instance.client;

  static Future<List<JobModel>> fetchData() async {
    List<JobModel> listOfJobs = [];
    try {
      final data = await _client.from('jobs').select();
      for (var job in data) {
        listOfJobs.add(JobModel.fromMap(job));
      }
    } on PostgrestException catch (ex) {
      print("Error ${ex.message}");
    }
    return listOfJobs;
  }

  static Future<List<JobModel>> fetchTrendingJobs() async {
    List<JobModel> listOfJobs = [];
    try {
      final data = await _client
          .from('jobs')
          .select()
          .eq('is_trending', true);
      for (var job in data) {
        listOfJobs.add(JobModel.fromMap(job));
      }
    } on PostgrestException catch (ex) {
      print("Error ${ex.message}");
    }
    return listOfJobs;
  }

  static Future<void> createJob(Map<String, dynamic> jobData) async {
    await _client.from('jobs').insert(jobData);
  }

  static Future<void> setTrending(int jobId, bool value) async {
    await _client
        .from('jobs')
        .update({'is_trending': value})
        .eq('id', jobId);
  }

  static Future<void> deleteJob(int jobId) async {
    await _client.from('jobs').delete().eq('id', jobId);
  }

  static Future<void> updateJob(int jobId, Map<String, dynamic> data) async {
    await _client.from('jobs').update(data).eq('id', jobId);
  }
}