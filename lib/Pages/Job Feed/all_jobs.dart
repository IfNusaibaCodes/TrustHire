import 'package:flutter/material.dart';
import 'package:trust_hire_app/API_Services/api_service.dart';
import 'package:trust_hire_app/Common/Component/job_item_list.dart';

import '../../Model/job_model.dart';

class AllJobs extends StatefulWidget {
  const AllJobs({super.key});

  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {

  ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: apiService.getAllJobs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<JobModel>resultsList = snapshot.data ?? [];
              return ListView.builder(
                itemBuilder: (context, index) {
                  return JobItemList(jobModel: resultsList[index],);
                },
                itemCount: resultsList.length,
              );
            }
            return Center(child: CircularProgressIndicator(),);
          }
      ),

    );
  }
}
