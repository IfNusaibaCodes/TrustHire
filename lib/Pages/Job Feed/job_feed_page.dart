import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/reusable_widgets.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/trust_hire_app_bar.dart';

import '../../Model/job_model.dart';
import '../../admin/admin_service.dart';
import '../../admin/manage_trending_page.dart';
import '../Drawer/app_drawer.dart';
import 'all_jobs.dart';
import 'job_details.dart';
import 'jobs_database.dart';

class JobFeedPage extends StatefulWidget {
  const JobFeedPage({super.key});

  @override
  State<JobFeedPage> createState() => _JobFeedPageState();
}

class _JobFeedPageState extends State<JobFeedPage> {
  late Future<List<JobModel>> trendingJobsFuture;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    trendingJobsFuture = JobsDatabaseService.fetchTrendingJobs();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final admin = await AdminService.isAdmin();
    if (mounted) setState(() => _isAdmin = admin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: const AppDrawer(),
      appBar: const TrustHireAppBar(
        title: "Trust Hire",
        showLogo: true,
        showDrawer: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF4F6EF7),
          onRefresh: () async {
            setState(() {
              trendingJobsFuture = JobsDatabaseService.fetchTrendingJobs();
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Find Your Dream Job",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1F36),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Explore trending jobs and trusted opportunities",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 24),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AllJobs(),
                      ),
                    );
                  },
                  child: GradientBannerCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.work_outline_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Job Board",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Browse all available jobs from trusted companies and apply easily.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Explore Jobs",
                                style: TextStyle(
                                  color: Color(0xFF1A1F36),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                                color: Color(0xFF1A1F36),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Trending Jobs",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1F36),
                      ),
                    ),

                    Row(
                      children: [
                        if (_isAdmin)
                          TextButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ManageTrendingPage(),
                              ),
                            ),
                            icon: const Icon(Icons.edit_rounded, size: 16, color: Color(0xFF4F6EF7)),
                            label: const Text(
                              'Manage',
                              style: TextStyle(color: Color(0xFF4F6EF7), fontWeight: FontWeight.w700),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                FutureBuilder<List<JobModel>>(
                  future: trendingJobsFuture,
                  builder: (context, snapshot) {

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: CircularProgressIndicator(
                            color: Color(0xFF4F6EF7),
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "Failed to load jobs. Connect Internet",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

                    final jobs = snapshot.data ?? [];

                    if (jobs.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "No jobs available",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }

                  
                    final trendingJobs = jobs.take(5).toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: trendingJobs.length,
                      itemBuilder: (context, index) {
                        final job = trendingJobs[index];
                        return CompactJobCard(
                          job: job,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JobDetailsPage(job: job),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}