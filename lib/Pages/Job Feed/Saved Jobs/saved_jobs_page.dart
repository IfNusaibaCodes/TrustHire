import 'package:flutter/material.dart';
import 'package:trust_hire_app/Pages/Job%20Feed/Saved%20Jobs/saved_jobs_database.dart';
import '../../../Model/job_model.dart';
import '../job_details.dart';

class SavedJobsPage extends StatefulWidget {
  const SavedJobsPage({super.key});

  @override
  State<SavedJobsPage> createState() => _SavedJobsPageState();
}

class _SavedJobsPageState extends State<SavedJobsPage> {
  final _service = SavedJobsService();
  late Future<List<JobModel>> _savedFuture;

  @override
  void initState() {
    super.initState();
    _savedFuture = _service.fetchSavedJobs();
  }

  Future<void> _unsave(int jobId) async {
    await _service.unsaveJob(jobId);
    final newFuture = _service.fetchSavedJobs();
    setState(() => _savedFuture = newFuture);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Job removed from saved'),
        backgroundColor: const Color(0xFF6B7280),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F36),
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Saved Jobs',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: FutureBuilder<List<JobModel>>(
        future: _savedFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4F6EF7)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          }

          final jobs = snapshot.data ?? [];

          if (jobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_outline_rounded,
                      size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('No saved jobs yet',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Text('Tap the bookmark icon on any job to save it',
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade400)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Dismissible(
                key: Key(job.id.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _unsave(job.id),
                background: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => JobDetailsPage(job: job))),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [

                        // Company logo
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F2FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: job.companyLogo != null && job.companyLogo!.isNotEmpty
                              ? Image.network(job.companyLogo!, fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => _initials(job))
                              : _initials(job),
                        ),

                        const SizedBox(width: 14),

                        // Job info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job.companyName ?? 'Unknown Company',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280))),
                              const SizedBox(height: 4),
                              Text(job.title ?? 'Untitled Position',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A1F36)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              if (job.cityName != null)
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 12, color: Color(0xFF9CA3AF)),
                                    const SizedBox(width: 4),
                                    Text(job.cityName!,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF9CA3AF))),
                                  ],
                                ),
                            ],
                          ),
                        ),

                        // Unsave button
                        GestureDetector(
                          onTap: () => _unsave(job.id),
                          child: const Icon(Icons.bookmark_rounded,
                              color: Color(0xFF4F6EF7), size: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _initials(JobModel job) {
    final initials = job.companyName != null && job.companyName!.isNotEmpty
        ? job.companyName!.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join()
        : '?';
    return Center(
      child: Text(initials,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4F6EF7))),
    );
  }
}