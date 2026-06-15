import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/responsive.dart';

class AppLogo extends StatelessWidget {
  final double? iconSize;

  const AppLogo({
    super.key,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    Responsive().init(context);

    final double effectiveIconSize = iconSize ?? 24.sp;

    return Container(
      width: effectiveIconSize * 1.6,
      height: effectiveIconSize * 1.6,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 42, 96),
        borderRadius: BorderRadius.circular(effectiveIconSize * 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.work_outline_rounded,
        color: Colors.white,
        size: effectiveIconSize,
      ),
    );
  }
}
