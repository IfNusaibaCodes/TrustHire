import 'package:flutter/material.dart';

import '../../Model/job_model.dart';
import '../../Pages/Job Feed/Saved Jobs/saved_jobs_database.dart';
import '../../Pages/Job Feed/job_details.dart';

class JobItemList extends StatelessWidget {
  final List<JobModel> jobs;
  final bool isLoading;

  const JobItemList({
    super.key,
    required this.jobs,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // ── CHANGED: removed Scaffold + AppBar, returns content directly ──
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(color: Color(0xFF4F6EF7)),
    )
        : jobs.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        return _JobCard(job: jobs[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_outline_rounded, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No jobs available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new opportunities',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatefulWidget {
  final JobModel job;

  const _JobCard({required this.job});

  @override
  State<_JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<_JobCard> {

  final _savedService = SavedJobsService();
  bool _isSaved   = false;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    try {
      final ids = await _savedService.fetchSavedJobIds();
      if (mounted) setState(() => _isSaved = ids.contains(widget.job.id));
    } catch (_) {}
  }

  Future<void> _toggleSave() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final nowSaved = await _savedService.toggleSave(widget.job.id, _isSaved);
      if (mounted) {
        setState(() => _isSaved = nowSaved);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(nowSaved ? 'Job saved ✅' : 'Job removed from saved'),
          backgroundColor: nowSaved ? const Color(0xFF10B981) : const Color(0xFF6B7280),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: logo + company + remote badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CompanyLogo(logoUrl: widget.job.companyLogo, companyName: widget.job.companyName),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.job.companyName ?? 'Unknown Company',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.job.title ?? 'Untitled Position',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1F36),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _toggleSave,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _isSaved
                          ? const Color(0xFFEEF2FF)
                          : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _isSaved
                            ? const Color(0xFF4F6EF7)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF4F6EF7),
                      ),
                    )
                        : Icon(
                      _isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_outline_rounded,
                      size: 18,
                      color: _isSaved
                          ? const Color(0xFF4F6EF7)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),

                if (widget.job.hasRemote == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Remote',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F6EF7),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 14),

            // Meta chips row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (widget.job.cityName != null || widget.job.cityCountryName != null)
                  _MetaChip(
                    icon: Icons.location_on_outlined,
                    label: [widget.job.cityName, widget.job.cityCountryName]
                        .where((e) => e != null)
                        .join(', '),
                  ),
                if (widget.job.typePrimary != null)
                  _MetaChip(
                    icon: Icons.access_time_rounded,
                    label: widget.job.typePrimary!,
                  ),
                if (widget.job.experienceLevel != null)
                  _MetaChip(
                    icon: Icons.bar_chart_rounded,
                    label: widget.job.experienceLevel!,
                    accent: true,
                  ),
                if (widget.job.salaryCurrency != null)
                  _MetaChip(
                    icon: Icons.attach_money_rounded,
                    label: widget.job.salaryCurrency!,
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Description preview
            if (widget.job.descriptionMd != null && widget.job.descriptionMd!.isNotEmpty)
              Text(
                widget.job.descriptionMd!.replaceAll(RegExp(r'[#*`\[\]()>_~]'), '').trim(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),

            const SizedBox(height: 16),

            // Footer: published date + view more button
            Row(
              children: [
                if (widget.job.published != null)
                  Text(
                    _formatDate(widget.job.published!),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                const Spacer(),
                SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailsPage(job: widget.job),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1F36),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View More',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _CompanyLogo extends StatelessWidget {
  final String? logoUrl;
  final String? companyName;

  const _CompanyLogo({this.logoUrl, this.companyName});

  @override
  Widget build(BuildContext context) {
    final initials = companyName != null && companyName!.isNotEmpty
        ? companyName!.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join()
        : '?';

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      clipBehavior: Clip.antiAlias,
      child: logoUrl != null && logoUrl!.isNotEmpty
          ? Image.network(
        logoUrl!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Center(
          child: Text(
            initials,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4F6EF7),
            ),
          ),
        ),
      )
          : Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4F6EF7),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool accent;

  const _MetaChip({
    required this.icon,
    required this.label,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accent ? const Color(0xFFFFF7ED) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accent ? const Color(0xFFFED7AA) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: accent ? const Color(0xFFF97316) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: accent ? const Color(0xFFF97316) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}