import 'package:flutter/material.dart';


class StatusPill extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  final bool filled;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool border;

  const StatusPill({
    super.key,
    required this.text,
    required this.color,
    this.icon,
    this.filled = false,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.radius = 20,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : color;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(radius),
        border: border
            ? Border.all(color: color.withValues(alpha: 0.4))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
