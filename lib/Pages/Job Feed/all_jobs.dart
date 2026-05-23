import 'package:flutter/material.dart';
import 'package:trust_hire_app/Common/Component/job_item_list.dart';
import '../../Model/job_model.dart';
import 'jobs_database.dart';

class AllJobs extends StatefulWidget {
  const AllJobs({super.key});

  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  late final Future<List<JobModel>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = JobsDatabaseService.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<JobModel>>(
      future: _jobsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF4F6EF7)),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded,
                      size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load jobs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => setState(() {
                      _jobsFuture = JobsDatabaseService.fetchData();
                    }),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1F36),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final List<JobModel> jobs = snapshot.data ?? [];
        return JobItemList(jobs: jobs);
      },
    );
  }
}