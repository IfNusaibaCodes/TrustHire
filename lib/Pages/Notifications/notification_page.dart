import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/reusable_widgets.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import '../../admin/admin_service.dart';
import '../../admin/send_notification_form.dart';
import '../../Authentication/Controllers/notification_controller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
      backgroundColor: TColors.appScaffoldBg,
      floatingActionButton: _isAdmin
          ? FloatingActionButton.extended(
              onPressed: _openSendForm,
              backgroundColor: TColors.appNavy,
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              label: const Text('Send Notification',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            )
          : null,
      appBar: AppBar(
        backgroundColor: TColors.appNavy,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
    return Obx(() => FilterChipsRow<String?>(
          values: _filterLabels.keys.toList(),
          selected: c.activeFilter.value,
          labelOf: (k) => _filterLabels[k]!,
          onSelected: c.setFilter,
        ));
  }

  Widget _body(NotificationController c) {
    return Obx(() {
      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: TColors.appBlue));
      }

      if (c.hasError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 12),
              const Text('Failed to load notifications',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: TColors.appNavy)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: c.load,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.appNavy, foregroundColor: Colors.white,
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
                fontSize: 18, fontWeight: FontWeight.w600, color: TColors.appNavy,
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
          itemBuilder: (_, i) => NotificationCard(notif: list[i], onTap: () => c.markRead(list[i].id)),
        ),
      );
    });
  }
}
