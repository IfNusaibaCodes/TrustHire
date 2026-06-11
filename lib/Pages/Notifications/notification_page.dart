import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/reusable_widgets.dart';
import '../../admin/admin_service.dart';
import '../../admin/send_notification_form.dart';
import 'notification_controller.dart';
import 'notification_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const _bg      = Color(0xFFF5F7FA);
  static const _navy    = Color(0xFF1A1F36);
  static const _primary = Color(0xFF4F6EF7);

  static const _filterLabels = {
    null:        'All',
    'job_alert': 'Job Alerts',
    'trending':  'Trending',
    'general':   'General',
    'tip':       'Tips',
  };

  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final admin = await AdminService.isAdmin();
    if (mounted) setState(() => _isAdmin = admin);
  }

  void _openSendForm() {
    final c = Get.find<NotificationController>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SendNotificationForm(onSent: c.load),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: _isAdmin
          ? FloatingActionButton.extended(
              onPressed: _openSendForm,
              backgroundColor: _navy,
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              label: const Text('Send Notification',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            )
          : null,
      appBar: AppBar(
        backgroundColor: _navy,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        actions: [
          Obx(() {
            final hasUnread = c.unreadCount > 0;
            if (!hasUnread) return const SizedBox.shrink();
            return TextButton(
              onPressed: c.markAllRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          _filterRow(c),
          Expanded(child: _body(c)),
        ],
      ),
    );
  }

  Widget _filterRow(NotificationController c) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Obx(() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filterLabels.entries.map((entry) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AppFilterChip(
              label: entry.value,
              selected: c.activeFilter.value == entry.key,
              onTap: () => c.setFilter(entry.key),
            ),
          )).toList(),
        ),
      )),
    );
  }

  Widget _body(NotificationController c) {
    return Obx(() {
      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: _primary));
      }

      if (c.hasError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 12),
              const Text('Failed to load notifications',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _navy)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: c.load,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _navy, foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      }

      final list = c.filtered;

      if (list.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_off_outlined, size: 72, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              const Text('No notifications', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: _navy,
              )),
              const SizedBox(height: 8),
              Text("You're all caught up!", style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: c.load,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: list.length,
          itemBuilder: (_, i) => _NotifCard(notif: list[i], onTap: () => c.markRead(list[i].id)),
        ),
      );
    });
  }
}

// ── Notification card ─────────────────────────────────────────────────────────
class _NotifCard extends StatelessWidget {
  final NotificationModel notif;
  final VoidCallback onTap;

  const _NotifCard({required this.notif, required this.onTap});

  static const _navy    = Color(0xFF1A1F36);
  static const _primary = Color(0xFF4F6EF7);
  static const _grey    = Color(0xFF9CA3AF);

  IconData get _icon {
    switch (notif.type) {
      case 'job_alert': return Icons.work_outline_rounded;
      case 'trending':  return Icons.trending_up_rounded;
      case 'tip':       return Icons.lightbulb_outline_rounded;
      default:          return Icons.campaign_outlined;
    }
  }

  Color get _iconColor {
    switch (notif.type) {
      case 'job_alert': return _primary;
      case 'trending':  return const Color(0xFF10B981);
      case 'tip':       return const Color(0xFFF59E0B);
      default:          return const Color(0xFF8B5CF6);
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1)  return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    if (diff.inDays < 7)     return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final unread = !notif.isRead;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: unread ? const Color(0xFFEEF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: unread ? _primary.withValues(alpha: 0.25) : const Color(0xFFF0F0F0),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, color: _iconColor, size: 22),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                            color: _navy,
                          ),
                        ),
                      ),
                      if (unread)
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(color: _primary, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.body,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _timeAgo(notif.createdAt),
                    style: const TextStyle(fontSize: 11, color: _grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
