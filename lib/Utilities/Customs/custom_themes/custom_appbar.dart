import 'package:flutter/material.dart';

class TAppBar {
  TAppBar._();



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




}