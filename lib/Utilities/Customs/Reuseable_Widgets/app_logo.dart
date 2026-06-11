import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
class AppLogo extends StatelessWidget {
  final double? size;
  const AppLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = size ?? screenWidth * 0.1;

    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        color: TColors.appNavy,
        borderRadius: BorderRadius.circular(logoSize * 0.25),
      ),
      child: Icon(
        Icons.shield,
        color: Colors.white,
        size: logoSize * 0.6,
      ),
    );
  }
}