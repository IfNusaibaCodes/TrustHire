import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Model/job_model.dart';

class JobsDatabaseService {
  static Future<List<JobModel>> fetchData() async {
    final client = Supabase.instance.client;
    List<JobModel> listOfJobs = [];

    try {
      final data = await client.from('jobs').select();
      for (var job in data) {
        listOfJobs.add(JobModel.fromMap(job));
      }
    } on PostgrestException catch (ex) {
      print("Error ${ex.message}");
    }

    return listOfJobs;
  }
}