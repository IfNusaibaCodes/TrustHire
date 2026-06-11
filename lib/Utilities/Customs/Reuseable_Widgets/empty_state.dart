import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';

/// A centred "nothing here yet" placeholder: an icon, a title and an
/// optional message. Used for empty lists / error states.
///
/// Example:
/// ```dart
/// EmptyState(
///   icon: Icons.notifications_off_outlined,
///   title: 'No notifications',
///   message: "You're all caught up!",
/// )
/// ```
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Color iconColor;
  final double iconSize;

  /// Optional action button (e.g. "Retry").
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.iconColor = TColors.appTextGrey,
    this.iconSize = 64,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: TColors.appTextDark,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 6),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: TColors.appTextGrey,
              ),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.appNavy,
                foregroundColor: Colors.white,
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
