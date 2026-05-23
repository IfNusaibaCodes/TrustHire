import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';

class BackButton extends StatelessWidget {
  const BackButton({this.onTap,});

  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: TColors.softGrey,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.chevron_left_rounded,
          size: 22,
          color: Colors.black,
        ),
      ),
    );
  }
}