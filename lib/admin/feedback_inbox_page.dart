import 'package:flutter/material.dart';
import '../Pages/Drawer/Feedback_Support/feedback_database.dart';
import '../Pages/Drawer/Feedback_Support/feedback_model.dart';

class FeedbackInboxPage extends StatefulWidget {
  const FeedbackInboxPage({super.key});

  @override
  State<FeedbackInboxPage> createState() => _FeedbackInboxPageState();
}

class _FeedbackInboxPageState extends State<FeedbackInboxPage> {
  static const _navy    = Color(0xFF1A1F36);
  static const _primary = Color(0xFF4F6EF7);
  static const _bg      = Color(0xFFF5F7FA);

  List<FeedbackModel> _all      = [];
  bool                _loading  = true;
  String?             _filter;   // null = All

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await FeedbackService.fetchAllFeedback();
    if (mounted) setState(() { _all = data; _loading = false; });
  }

  List<FeedbackModel> get _filtered =>
      _filter == null ? _all : _all.where((f) => f.rating == _filter).toList();

  List<String> get _ratingOptions {
    final seen = <String>{};
    for (final f in _all) { seen.add(f.rating); }
    return seen.toList()..sort();
  }

  Future<void> _delete(FeedbackModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Feedback',
            style: TextStyle(fontWeight: FontWeight.w800, color: _navy)),
        content: const Text('Remove this feedback entry?'),
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
      await FeedbackService.deleteFeedback(item.id);
      setState(() => _all.removeWhere((f) => f.id == item.id));
      if (mounted) _snack('Deleted', success: true);
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
        title: const Text('Feedback Inbox',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text('${_all.length} total',
                  style: const TextStyle(color: Colors.white60, fontSize: 13)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Filter chips ────────────────────────────────────
          if (!_loading && _all.isNotEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(label: 'All', selected: _filter == null,
                        onTap: () => setState(() => _filter = null)),
                    ..._ratingOptions.map((r) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: r,
                        selected: _filter == r,
                        onTap: () => setState(() => _filter = r),
                        color: _ratingColor(r),
                      ),
                    )),
                  ],
                ),
              ),
            ),

          // ── List ───────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _primary))
                : _filtered.isEmpty
                    ? const Center(
                        child: Text('No feedback yet',
                            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15)))
                    : RefreshIndicator(
                        onRefresh: _load,
                        color: _primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) => _FeedbackCard(
                            item: _filtered[i],
                            onDelete: () => _delete(_filtered[i]),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Color _ratingColor(String rating) {
    switch (rating.toLowerCase()) {
      case 'good':
      case 'excellent':
      case 'great':       return const Color(0xFF10B981);
      case 'bad':
      case 'poor':        return Colors.red;
      case 'neutral':
      case 'okay':
      case 'average':     return const Color(0xFFF59E0B);
      default:            return _primary;
    }
  }
}

// ── Filter chip ────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({required this.label, required this.selected, required this.onTap, this.color});

  static const _navy = Color(0xFF1A1F36);

  @override
  Widget build(BuildContext context) {
    final c = color ?? _navy;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? c : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? c : const Color(0xFFE5E7EB)),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF6B7280))),
      ),
    );
  }
}

// ── Feedback card ──────────────────────────────────────────────
class _FeedbackCard extends StatelessWidget {
  final FeedbackModel item;
  final VoidCallback  onDelete;

  const _FeedbackCard({required this.item, required this.onDelete});

  static const _navy = Color(0xFF1A1F36);

  Color _ratingColor(String r) {
    switch (r.toLowerCase()) {
      case 'good': case 'excellent': case 'great': return const Color(0xFF10B981);
      case 'bad':  case 'poor':                    return Colors.red;
      default:                                     return const Color(0xFFF59E0B);
    }
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60)  return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24)  return '${diff.inHours}h ago';
    if (diff.inDays    < 7)   return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final rc = _ratingColor(item.rating);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Header row ─────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: rc.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item.rating,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: rc)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item.feature,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                        color: Color(0xFF4F6EF7))),
              ),
              const Spacer(),
              Text(_timeAgo(item.createdAt),
                  style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
              ),
            ],
          ),

          // ── Problem ─────────────────────────────────────────
          if (item.problem?.isNotEmpty == true) ...[
            const SizedBox(height: 10),
            const Text('Problem', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                color: Color(0xFF6B7280), letterSpacing: 0.4)),
            const SizedBox(height: 3),
            Text(item.problem!, style: const TextStyle(fontSize: 14, color: _navy, height: 1.4)),
          ],

          // ── Suggestion ──────────────────────────────────────
          if (item.suggestion?.isNotEmpty == true) ...[
            const SizedBox(height: 10),
            const Text('Suggestion', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                color: Color(0xFF6B7280), letterSpacing: 0.4)),
            const SizedBox(height: 3),
            Text(item.suggestion!, style: const TextStyle(fontSize: 14, color: _navy, height: 1.4)),
          ],

          // ── Contact info ────────────────────────────────────
          if (item.email?.isNotEmpty == true || item.phone?.isNotEmpty == true) ...[
            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 8),
            Row(
              children: [
                if (item.email?.isNotEmpty == true) ...[
                  const Icon(Icons.email_outlined, size: 14, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 4),
                  Text(item.email!, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                ],
                if (item.email?.isNotEmpty == true && item.phone?.isNotEmpty == true)
                  const SizedBox(width: 12),
                if (item.phone?.isNotEmpty == true) ...[
                  const Icon(Icons.phone_outlined, size: 14, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 4),
                  Text(item.phone!, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
