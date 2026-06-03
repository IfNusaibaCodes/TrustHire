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
  late Future<List<JobModel>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = JobsDatabaseService.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // ── Scaffold + AppBar moved here from JobItemList ──────────
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F36),
        elevation: 0,
        title: const Text(
          'Job Feed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFF2D3561), height: 1),
        ),
      ),
      body: FutureBuilder<List<JobModel>>(
        future: _jobsFuture,
        builder: (context, snapshot) {

          // ── Loading ──────────────────────────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4F6EF7)),
            );
          }

          // ── Error ────────────────────────────────────────────
          if (snapshot.hasError) {
            return Center(
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
            );
          }

          // ── Data ─────────────────────────────────────────────
          final List<JobModel> jobs = snapshot.data ?? [];
          return JobItemList(jobs: jobs);
        },
      ),
    );
  }
}