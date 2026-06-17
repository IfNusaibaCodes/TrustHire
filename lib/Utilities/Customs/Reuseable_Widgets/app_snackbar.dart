import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';


void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
  Color? background,
  Duration duration = const Duration(seconds: 2),
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      backgroundColor:
          background ?? (isError ? TColors.appError : TColors.appSuccess),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
      duration: duration,
    ),
  );
}
