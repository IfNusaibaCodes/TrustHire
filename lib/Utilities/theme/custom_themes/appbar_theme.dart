import 'package:flutter/material.dart';

class TAppBarTheme {
  TAppBarTheme._();


//Light Theme
  static final lightAppBarTheme = AppBarThemeData(
        elevation: 0,
        centerTitle: false,
    scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
       iconTheme: IconThemeData(color: Colors.black, size: 24),
        actionsIconTheme: IconThemeData(color: Colors.black, size: 24) ,
        titleTextStyle: const TextStyle( fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),


  );

//Dark Theme
  static final darkAppBarTheme = AppBarThemeData(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black, size: 24),
    actionsIconTheme: IconThemeData(color: Colors.white, size: 24) ,
    titleTextStyle: const TextStyle( fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),


  );



}