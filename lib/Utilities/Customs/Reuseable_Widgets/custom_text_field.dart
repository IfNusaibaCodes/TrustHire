import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    required this.onTap,
    this.buttonColor,
    this.borderRadius,
    this.textColor,
    required this.buttonText,
    Key? key,
  }) : super(key: key);

  VoidCallback onTap;
  Color? buttonColor;
  double? borderRadius;
  Color? textColor;
  String buttonText;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsGeometry.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: buttonColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: textColor ?? Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),


        ),
      ),
    );
  }
}

