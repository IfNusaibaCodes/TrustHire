import 'package:flutter/material.dart';

// ─── JOB LIST TAB ─────────────────────────────────────────────────────────────
// Tab 2 of AdminPanelPage. Shows all posted jobs with search/filter.
// Receives job list from AdminPanelPage (no direct Supabase calls here).

class JobListTab extends StatefulWidget {
  final List<Map<String, dynamic>> jobs;
  final bool loading;

  const JobListTab({super.key, required this.jobs, required this.loading});

  @override
  State<JobListTab> createState() => _JobListTabState();
}

class _JobListTabState extends State<JobListTab> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    if (_query.isEmpty) return widget.jobs;
    final q = _query.toLowerCase();
    return widget.jobs.where((job) {
      return (job['title']            ?? '').toString().toLowerCase().contains(q)
          || (job['company']          ?? '').toString().toLowerCase().contains(q)
          || (job['location']         ?? '').toString().toLowerCase().contains(q)
          || (job['country']          ?? '').toString().toLowerCase().contains(q)
          || (job['job_type']         ?? '').toString().toLowerCase().contains(q)
          || (job['experience_level'] ?? '').toString().toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF1A6BFF)));
    }

    if (widget.jobs.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 72, height: 72,
              decoration: BoxDecoration(color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.work_off_outlined, size: 32, color: Color(0xFF1A6BFF))),
          const SizedBox(height: 16),
          const Text('No jobs posted yet',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16,
                  fontWeight: FontWeight.w600, color: Color(0xFF131B2E))),
          const SizedBox(height: 6),
          const Text('Post your first job from the "Post New Job" tab',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF727687))),
        ]),
      );
    }

    final filtered = _filtered;

    return Column(
      children: [

        // ── Search Bar ──────────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v.trim()),
                style: const TextStyle(
                    fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF131B2E)),
                decoration: InputDecoration(
                  hintText: 'Search by title, company, location...',
                  hintStyle: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 12, color: Color(0xFFADB5BD)),
                  prefixIcon: const Icon(Icons.search_rounded,
                      size: 20, color: Color(0xFF727687)),
                  suffixIcon: _query.isNotEmpty
                      ? GestureDetector(
                    onTap: () {
                      _searchCtrl.clear();
                      setState(() => _query = '');
                    },
                    child: const Icon(Icons.close_rounded,
                        size: 18, color: Color(0xFF727687)),
                  )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFFF7F9FC),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1A6BFF), width: 1.5)),
                ),
              ),
              if (_query.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(children: [
                    const Icon(Icons.filter_list_rounded, size: 14, color: Color(0xFF1A6BFF)),
                    const SizedBox(width: 5),
                    Text(
                      '${filtered.length} result${filtered.length == 1 ? '' : 's'} for "$_query"',
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Color(0xFF1A6BFF),
                          fontWeight: FontWeight.w500),
                    ),
                  ]),
                ),
            ],
          ),
        ),

        // ── No Results ─────────────────────────────────────────
        if (filtered.isEmpty)
          Expanded(
            child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF7F9FC),
                        borderRadius: BorderRadius.circular(18)),
                    child: const Icon(Icons.search_off_rounded,
                        size: 30, color: Color(0xFF727687))),
                const SizedBox(height: 14),
                const Text('No results found',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 15,
                        fontWeight: FontWeight.w600, color: Color(0xFF131B2E))),
                const SizedBox(height: 6),
                const Text('Try a different keyword',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
                        color: Color(0xFF727687))),
              ]),
            ),
          )

        // ── Job List ───────────────────────────────────────────
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) => _buildJobTile(filtered[i], i),
            ),
          ),
      ],
    );
  }

  Widget _buildJobTile(Map<String, dynamic> job, int index) {
    final bool isRemote   = job['has_remote'] == true;
    final String expLevel = (job['experience_level'] ?? 'N/A').toString();
    final String jobType  = (job['job_type'] ?? '').toString();
    final String location = (job['location'] ?? 'N/A').toString();
    final String company  = (job['company'] ?? '').toString();
    final String salary   = (job['salary'] ?? '').toString();
    final String country  = (job['country'] ?? '').toString();

    String publishedStr = '';
    if (job['published'] != null) {
      final dt = DateTime.tryParse(job['published'].toString());
      if (dt != null) {
        final diff = DateTime.now().difference(dt);
        if (diff.inDays == 0)      publishedStr = 'Today';
        else if (diff.inDays == 1) publishedStr = '1 day ago';
        else                       publishedStr = '${diff.inDays} days ago';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: isRemote ? const Color(0xFF1A6BFF) : const Color(0xFF006C4B),
            width: 3,
          ),
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: const Color(0xFFEEF4FF),
                borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text('${index + 1}',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 13,
                    fontWeight: FontWeight.bold, color: Color(0xFF1A6BFF)))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text((job['title'] ?? 'Untitled Job').toString(),
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 14,
                      fontWeight: FontWeight.w600, color: Color(0xFF131B2E)),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              if (company.isNotEmpty)
                Text(company,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 11,
                        color: Color(0xFF1A6BFF), fontWeight: FontWeight.w500),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF727687)),
                const SizedBox(width: 3),
                Expanded(child: Text(
                    country.isNotEmpty ? '$location · $country' : location,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 11,
                        color: Color(0xFF727687)),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 6),
              Wrap(spacing: 6, runSpacing: 4, children: [
                if (isRemote) _pill('Remote', const Color(0xFFEEF4FF), const Color(0xFF1A6BFF)),
                _pill(expLevel, const Color(0xFFF2F3FF), const Color(0xFF0053D3)),
                if (jobType.isNotEmpty)
                  _pill(jobType, const Color(0xFFF0FDF4), const Color(0xFF006C4B)),
                if (salary.isNotEmpty)
                  _pill(salary, const Color(0xFFFFF4E5), const Color(0xFFD97706)),
                if (publishedStr.isNotEmpty)
                  _pill(publishedStr, const Color(0xFFF7F9FC), const Color(0xFF727687)),
              ]),
            ]),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFFE2E8F0)),
        ]),
      ),
    );
  }

  Widget _pill(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 10,
          fontWeight: FontWeight.w600, color: textColor)),
    );
  }
}