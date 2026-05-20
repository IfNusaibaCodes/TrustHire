import 'dart:convert';

import 'package:http/http.dart';
import 'package:trust_hire_app/Model/job_model.dart';

class ApiService {
  final all_job_url = "https://jobdataapi.com/api/jobs/?country_code=BD&description_md=true&description_off=true";



  Future<List<JobModel>> getAllJobs()async{
    try{
      Response response = await get(Uri.parse(all_job_url));
      if(response.statusCode == 200){
        Map<String,dynamic> json =jsonDecode(response.body);
        List<dynamic>body = json['results'];
        List<JobModel>resultsList = body.map((item) => JobModel.fromJson(item)).toList();
        return resultsList;
      }else{
        throw ("no jobs found");
      }

    }catch(e){
      print(e.toString());
      throw e;
    }
  }




}