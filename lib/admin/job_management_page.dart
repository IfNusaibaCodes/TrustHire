import 'package:flutter/material.dart';
import '../Model/job_model.dart';
import '../Pages/Job Feed/jobs_database.dart';
import 'edit_job_form.dart';

class JobManagementPage extends StatefulWidget {
  const JobManagementPage({super.key});

  @override
  State<JobManagementPage> createState() => _JobManagementPageState();
}

class _JobManagementPageState extends State<JobManagementPage> {
  static const _navy    = Color(0xFF1A1F36);
  static const _primary = Color(0xFF4F6EF7);
  static const _bg      = Color(0xFFF5F7FA);

  List<JobModel> _jobs     = [];
  bool           _loading  = true;
  String         _search   = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final jobs = await JobsDatabaseService.fetchData();
    if (mounted) setState(() { _jobs = jobs; _loading = false; });
  }

  List<JobModel> get _filtered {
    if (_search.isEmpty) return _jobs;
    final q = _search.toLowerCase();
    return _jobs.where((j) =>
        (j.title ?? '').toLowerCase().contains(q) ||
        (j.companyName ?? '').toLowerCase().contains(q)).toList();
  }

  void _openEdit(JobModel job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditJobForm(job: job, onSaved: _load),
    );
  }

  Future<void> _confirmDelete(JobModel job) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Job', style: TextStyle(fontWeight: FontWeight.w800, color: _navy)),
        content: Text('Remove "${job.title}" from ${job.companyName}? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await JobsDatabaseService.deleteJob(job.id);
      setState(() => _jobs.removeWhere((j) => j.id == job.id));
      if (mounted) _snack('Job deleted', success: true);
    } catch (e) {
      if (mounted) _snack('Failed: $e');
    }
  }

  Future<void> _toggleTrending(JobModel job) async {
    final newVal = !(job.isTrending ?? false);
    try {
      await JobsDatabaseService.setTrending(job.id, newVal);
      await _load();
    } catch (e) {
      if (mounted) _snack('Failed: $e');
    }
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: success ? const Color(0xFF10B981) : Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Job Management',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text('${_jobs.length} jobs',
                  style: const TextStyle(color: Colors.white60, fontSize: 13)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search jobs or companies...',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9CA3AF), size: 20),
                filled: true,
                fillColor: _bg,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _primary))
                : _filtered.isEmpty
                    ? const Center(
                        child: Text('No jobs found',
                            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15)))
                    : RefreshIndicator(
                        onRefresh: _load,
                        color: _primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) => _JobTile(
                            job: _filtered[i],
                            onDelete: () => _confirmDelete(_filtered[i]),
                            onToggleTrending: () => _toggleTrending(_filtered[i]),
                            onEdit: () => _openEdit(_filtered[i]),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _JobTile extends StatelessWidget {
  final JobModel     job;
  final VoidCallback onDelete;
  final VoidCallback onToggleTrending;
  final VoidCallback onEdit;

  const _JobTile({
    required this.job,
    required this.onDelete,
    required this.onToggleTrending,
    required this.onEdit,
  });

  static const _navy    = Color(0xFF1A1F36);
  static const _primary = Color(0xFF4F6EF7);

  @override
  Widget build(BuildContext context) {
    final trending = job.isTrending ?? false;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                job.companyName?.isNotEmpty == true ? job.companyName![0].toUpperCase() : '?',
                style: const TextStyle(fontWeight: FontWeight.w700, color: _primary, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.title ?? 'Untitled',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _navy)),
                const SizedBox(height: 3),
                Text(job.companyName ?? 'Unknown',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (job.typePrimary != null) _chip(job.typePrimary!, _primary),
                    if (trending) ...[
                      const SizedBox(width: 6),
                      _chip('Trending', const Color(0xFF10B981)),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Actions
          Column(
            children: [
              GestureDetector(
                onTap: onEdit,
                child: const Icon(Icons.edit_outlined, color: Color(0xFF4F6EF7), size: 22),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onToggleTrending,
                child: Icon(
                  trending ? Icons.trending_up_rounded : Icons.trending_flat_rounded,
                  color: trending ? const Color(0xFF10B981) : const Color(0xFF9CA3AF),
                  size: 22,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
  );
}
