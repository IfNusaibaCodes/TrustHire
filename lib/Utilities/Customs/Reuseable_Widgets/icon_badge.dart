import 'package:flutter/material.dart';

/// A small tinted square/circle holding an icon or emoji.
/// Used as the leading "chip" on cards, list rows, headers, etc.
///
/// Examples:
/// ```dart
/// IconBadge(icon: Icons.bolt, color: TColors.appPrimary);     // padded square
/// IconBadge(icon: Icons.send, color: green, circle: true, dimension: 40);
/// IconBadge(color: orange, child: const Text('🔥', style: TextStyle(fontSize: 26)));
/// ```
class IconBadge extends StatelessWidget {
  /// Provide either [icon] or a custom [child] (e.g. an emoji Text).
  final IconData? icon;
  final Widget? child;

  /// Tint colour. Background is this colour at [bgOpacity]; the icon uses
  /// [iconColor] (defaults to [color]).
  final Color color;
  final Color? iconColor;
  final double bgOpacity;

  /// Explicit background colour. When set it overrides the tinted [color].
  final Color? background;

  final double iconSize;

  /// Fixed box size. When null the badge sizes to [padding] around its child.
  final double? dimension;
  final EdgeInsetsGeometry padding;

  /// Circle when true, otherwise a rounded square with [radius].
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
