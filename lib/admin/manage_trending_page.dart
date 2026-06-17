import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/reusable_widgets.dart';
import '../Model/job_model.dart';
import '../Pages/Job Feed/jobs_database.dart';

class ManageTrendingPage extends StatefulWidget {
  const ManageTrendingPage({super.key});

  @override
  State<ManageTrendingPage> createState() => _ManageTrendingPageState();
}

class _ManageTrendingPageState extends State<ManageTrendingPage> {
  late Future<List<JobModel>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = JobsDatabaseService.fetchData();
  }

  Future<void> _toggle(JobModel job, bool newValue) async {
    try {
      await JobsDatabaseService.setTrending(job.id, newValue);
      if (mounted) setState(() { _jobsFuture = JobsDatabaseService.fetchData(); });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F36),
        elevation: 0,
        title: const Text(
          'Manage Trending Jobs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<JobModel>>(
        future: _jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF4F6EF7)));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final jobs = snapshot.data ?? [];
          if (jobs.isEmpty) {
            return const Center(
              child: Text('No jobs found', style: TextStyle(color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              // read is_trending from DB — we need it in the model fetch
              // For now we use a workaround: track via the raw fetch
              return _TrendingJobTile(job: job, onToggle: _toggle);
            },
          );
        },
      ),
    );
  }
}

class _TrendingJobTile extends StatefulWidget {
  final JobModel job;
  final Future<void> Function(JobModel job, bool value) onToggle;

  const _TrendingJobTile({required this.job, required this.onToggle});

  @override
  State<_TrendingJobTile> createState() => _TrendingJobTileState();
}

class _TrendingJobTileState extends State<_TrendingJobTile> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CompanyLogo(
            companyName: widget.job.companyName,
            size: 44,
            showBorder: false,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.job.title ?? 'Untitled',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.job.companyName ?? 'Unknown company',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          if (_loading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF4F6EF7)),
            )
          else
            Switch(
              value: widget.job.isTrending ?? false,
              onChanged: (v) async {
                setState(() => _loading = true);
                await widget.onToggle(widget.job, v);
                if (mounted) setState(() => _loading = false);
              },
              activeThumbColor: const Color(0xFF4F6EF7),
            ),
        ],
      ),
    );
  }
}
