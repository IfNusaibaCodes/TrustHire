import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/size.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;

  final Color? accentColor;
  final double accentWidth;

  final BoxBorder? border;

  final bool shadow;
  final bool fullWidth;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = Tsize.CardRadiusLg, // 16
    this.color = Colors.white,
    this.accentColor,
    this.accentWidth = 4,
    this.border,
    this.shadow = true,
    this.fullWidth = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: fullWidth ? double.infinity : null,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: accentColor != null
            ? Border(left: BorderSide(color: accentColor!, width: accentWidth))
            : border,
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }
}
