import 'package:flutter/material.dart';
import 'Themes/appbar_theme.dart';
import 'Themes/checkbox_theme.dart';
import 'Themes/elevated_button_theme.dart';
import 'Themes/outlined_button_theme.dart';
import 'Themes/text_theme.dart';
import 'Themes/text_field_theme.dart';


class TCustomApp{
  TCustomApp._();

  static ThemeData customTheme = ThemeData(
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
    inputDecorationTheme: TTextField.inputDecoration
      );




}