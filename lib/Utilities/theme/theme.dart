import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/theme/custom_themes/checkbox_theme.dart';
import 'package:trust_hire_app/Utilities/theme/custom_themes/outlined_button.dart';
import 'package:trust_hire_app/Utilities/theme/custom_themes/text_theme.dart';
import 'package:trust_hire_app/Utilities/theme/custom_themes/elevated_button_theme.dart';

import 'custom_themes/appbar_theme.dart';

class TAppTheme{
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Color(0xFF64B5F6),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TtextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme

      );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Color(0xFF64B5F6),
    scaffoldBackgroundColor: Colors.black,
    textTheme: TtextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme


  );



}