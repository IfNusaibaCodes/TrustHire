import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/app_card.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/icon_badge.dart';

/// A compact KPI/stat card: a circular [IconBadge] over a bold [value] and a
/// small [label], wrapped in an [AppCard]. Typically placed in a Row of three.
///
/// Example:
/// ```dart
/// StatCard(
///   label: 'Applied',
///   value: '12',
///   icon: Icons.send_rounded,
///   color: TColors.appBlue,
///   background: const Color(0xFFEEF2FF),
/// )
/// ```
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color background;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      radius: 18,
      child: Column(
        children: [
          IconBadge(
            icon: icon,
            color: color,
            background: background,
            circle: true,
            dimension: 40,
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: TColors.appTextDark)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: TColors.appTextGrey)),
        ],
      ),
    );
  }
}
