import 'package:flutter/material.dart';
import 'package:trust_hire_app/Common/Component/job_item_list.dart';
import '../../Model/job_model.dart';
import '../../admin/admin_service.dart';
import '../../admin/create_job_form.dart';
import 'jobs_database.dart';

class AllJobs extends StatefulWidget {
  const AllJobs({super.key});

  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  // ── State ────────────────────────────────────────────────────
  List<JobModel> _allJobs      = [];
  String         _searchQuery  = '';
  String         _selectedType = 'All';
  bool           _isLoading    = true;
  String?        _error;
  bool           _isAdmin      = false;

  final _searchController = TextEditingController();

  static const _filters = ['All', 'Full-time', 'Part-time', 'Remote', 'Recent'];

  // ── Filtering logic (single place) ───────────────────────────
  List<JobModel> get _filteredJobs {
    var list = _allJobs;

    // Step A — chip filter
    if (_selectedType == 'Remote') {
      list = list.where((j) => j.hasRemote == true).toList();
    } else if (_selectedType == 'Recent') {
      final cutoff = DateTime.now().subtract(const Duration(days: 7));
      list = list.where((j) => j.published != null && j.published!.isAfter(cutoff)).toList();
    } else if (_selectedType != 'All') {
      // Normalize both sides: remove dashes, underscores, spaces so
      // "Full-time" matches "full_time", "Full Time", "fulltime", etc.
      String normalize(String s) =>
          s.toLowerCase().replaceAll(RegExp(r'[-_\s]'), '');
      final key = normalize(_selectedType);
      list = list.where((j) =>
        normalize(j.typePrimary ?? '').contains(key)
      ).toList();
    }

    // Step B — text filter (substring, case-insensitive, OR across fields)
    final q = _searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((j) =>
        (j.title           ?? '').toLowerCase().contains(q) ||
        (j.companyName     ?? '').toLowerCase().contains(q) ||
        (j.cityName        ?? '').toLowerCase().contains(q) ||
        (j.cityCountryName ?? '').toLowerCase().contains(q),
      ).toList();
    }

    return list;
  }

  // ── Lifecycle ─────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadJobs();
    _checkAdmin();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final jobs = await JobsDatabaseService.fetchData();
      if (mounted) setState(() { _allJobs = jobs; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _checkAdmin() async {
    final admin = await AdminService.isAdmin();
    if (mounted) setState(() => _isAdmin = admin);
  }

  void _openCreateForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateJobForm(onJobCreated: _loadJobs),
    );
  }

  // ── Build ─────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      floatingActionButton: _isAdmin
          ? FloatingActionButton.extended(
              onPressed: _openCreateForm,
              backgroundColor: const Color(0xFF1A1F36),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text(
                'Post Job',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            )
          : null,
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
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search jobs, companies, cities…',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.white54, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: const Icon(Icons.close_rounded, color: Colors.white54, size: 18),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _filterChips(),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  // ── Filter chips row ──────────────────────────────────────────
  Widget _filterChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((f) {
            final selected = f == _selectedType;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedType = f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF1A1F36) : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? const Color(0xFF1A1F36) : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Text(
                    f,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Body: loading / error / list ──────────────────────────────
  Widget _body() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF4F6EF7)));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            const Text(
              'Failed to load jobs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadJobs,
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

    final results = _filteredJobs;

    if (results.isEmpty && (_searchQuery.isNotEmpty || _selectedType != 'All')) {
      return _emptySearch();
    }

    return JobItemList(jobs: results);
  }

  // ── Empty search state ────────────────────────────────────────
  Widget _emptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No results found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36)),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different keyword or filter',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              _searchController.clear();
              setState(() { _searchQuery = ''; _selectedType = 'All'; });
            },
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF4F6EF7)),
            label: const Text('Clear filters', style: TextStyle(color: Color(0xFF4F6EF7), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
