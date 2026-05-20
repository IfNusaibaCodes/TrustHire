import 'package:flutter/material.dart';


import 'custom_themes/custom_appbar.dart';
import 'custom_themes/custom_checkbox.dart';
import 'custom_themes/custom_elevated_button.dart';
import 'custom_themes/custom_outlined_button.dart';
import 'custom_themes/custom_text.dart';

class TCustomApp{
  TCustomApp._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Color(0xFF64B5F6),
    scaffoldBackgroundColor: Colors.white,
    textTheme: Ttext.lightTextTheme,
    elevatedButtonTheme: TElevatedButton.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButton.lightOutlinedButtonTheme,
    checkboxTheme: TCheckbox.lightCheckboxTheme,
    appBarTheme: TAppBar.lightAppBarTheme,


      );




}