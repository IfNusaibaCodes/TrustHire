import 'package:flutter/material.dart';
import 'package:trust_hire_app/Model/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notif;
  final VoidCallback onTap;

  const NotificationCard({super.key, required this.notif, required this.onTap});

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
