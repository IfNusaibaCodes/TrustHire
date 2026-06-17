import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Authentication/Controllers/notification_controller.dart';
import 'package:trust_hire_app/Pages/Notifications/notification_page.dart';
import 'package:trust_hire_app/profile/profile_page.dart';
import 'app_logo.dart';


class TrustHireAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogo;
  final bool showDrawer;
  final bool showBack;

  const TrustHireAppBar({
    super.key,
    required this.title,
    this.showLogo = false,
    this.showDrawer = false,
    this.showBack = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool hasLeading = showDrawer || showBack;
    return AppBar(
      elevation: 0,
      backgroundColor: TColors.appNavy,
      automaticallyImplyLeading: hasLeading,
      titleSpacing: hasLeading ? 0 : null,
      leading: showDrawer
          ? Builder(
              builder: (ctx) => IconButton(
                onPressed: () => Scaffold.of(ctx).openDrawer(),
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
              ),
            )
          : showBack
              ? IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                )
              : null,
      title: Row(
        children: [
          if (showLogo) ...[
            const AppLogo(iconSize: 18),
            const SizedBox(width: 10),
          ],
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: const [
        _NotificationsAction(),
        _ProfileAction(),
        SizedBox(width: 6),
      ],
    );
  }
}

class _NotificationsAction extends StatelessWidget {
  const _NotificationsAction();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Notifications',
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotificationPage()),
      ),
      icon: _buildIcon(),
    );
  }

  Widget _buildIcon() {
    const bell = Icon(Icons.notifications_none_rounded, color: Colors.white);

    if (!Get.isRegistered<NotificationController>()) return bell;

    final c = Get.find<NotificationController>();
    return Obx(() {
      final count = c.unreadCount;
      if (count == 0) return bell;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          bell,
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: const BoxDecoration(
                color: TColors.appError,
                shape: BoxShape.circle,
              ),
              child: Text(
                count > 9 ? '9+' : '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        ),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
