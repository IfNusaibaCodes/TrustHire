import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/app_card.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/section_header.dart';

/// An [AppCard] with a [SectionHeader] (icon + title + subtitle) on top and a
/// [child] body underneath — the standard "titled card" used on the growth,
/// planner and other dashboard-style pages.
///
/// Example:
/// ```dart
/// SectionCard(
///   icon: Icons.bar_chart_rounded,
///   title: 'Weekly Activity',
///   subtitle: 'Applications this week',
///   child: MyChart(),
/// )
/// ```
class SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(icon: icon, title: title, subtitle: subtitle),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
