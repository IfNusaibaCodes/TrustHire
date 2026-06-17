import 'package:flutter/material.dart';


class IconBadge extends StatelessWidget {
  final IconData? icon;
  final Widget? child;
  final Color color;
  final Color? iconColor;
  final double bgOpacity;
  final Color? background;
  final double iconSize;
  final double? dimension;
  final EdgeInsetsGeometry padding;
  final bool circle;
  final double radius;

  const IconBadge({
    super.key,
    this.icon,
    this.child,
    required this.color,
    this.iconColor,
    this.bgOpacity = 0.12,
    this.background,
    this.iconSize = 20,
    this.dimension,
    this.padding = const EdgeInsets.all(10),
    this.circle = false,
    this.radius = 12,
  }) : assert(icon != null || child != null,
            'IconBadge needs either an icon or a child');

  @override
  Widget build(BuildContext context) {
    final content =
        child ?? Icon(icon, size: iconSize, color: iconColor ?? color);

    return Container(
      width: dimension,
      height: dimension,
      alignment: dimension != null ? Alignment.center : null,
      padding: dimension == null ? padding : null,
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: bgOpacity),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(radius),
      ),
      child: content,
    );
  }
}
