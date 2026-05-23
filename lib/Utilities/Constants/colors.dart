import 'package:flutter/material.dart';

class TColors {
  TColors._();

  //App Basic Colors
  static const Color primaryColor = Colors.black;
  static const Color secondaryColor = Colors.white;
  static const Color accent = Color(0xFF7DA0CA);


  //Text Colors
  static const Color textDarkGrey = Color(0xFF333333);
  static const Color textLightGrey = Color(0xFF6C7570);
  static const Color textBlack = Colors.black;
  static const Color textWhite = Colors.white;

  //Background Colors
  static const Color lightBackground = Color(0xFFF6F6F6);
  static const Color darkBackground = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  //Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = TColors.white.withOpacity(0.1);


// Button Colors
  static const Color buttonPrimary = Colors.black;
  static const Color buttonSecondary = Color(0xFFFFC757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

// Border Colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

// Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

// Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);

}