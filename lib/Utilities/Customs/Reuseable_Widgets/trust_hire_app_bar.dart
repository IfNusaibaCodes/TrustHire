import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Pages/Notifications/notification_controller.dart';
import 'package:trust_hire_app/Pages/Notifications/notification_page.dart';
import 'package:trust_hire_app/profile/profile_page.dart';
import 'app_logo.dart';

/// Shared app bar used across the main tab pages (Job Feed, Scam Detector,
/// Planner, Growth).
///
/// - Job Feed passes [showLogo] + [showDrawer] to get the app logo, title and
///   the left-side drawer button.
/// - Other pages pass a [title] (page name) and get the same right-side
///   notifications + profile actions.
class TrustHireAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text shown next to / instead of the logo.
  final String title;

  /// When true, shows the [AppLogo] before the title (used by Job Feed).
  final bool showLogo;

  /// When true, shows the hamburger menu on the left that opens the drawer
  /// (used by Job Feed).
  final bool showDrawer;

  const TrustHireAppBar({
    super.key,
    required this.title,
    this.showLogo = false,
    this.showDrawer = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: TColors.appNavy,
      automaticallyImplyLeading: showDrawer,
      titleSpacing: showDrawer ? 0 : null,
      leading: showDrawer
          ? Builder(
              builder: (ctx) => IconButton(
                onPressed: () => Scaffold.of(ctx).openDrawer(),
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
              ),
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

/// Notifications bell with an unread-count badge (badge only shown when the
/// [NotificationController] is registered and there are unread items).
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

/// Rounded profile button on the right side.
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
