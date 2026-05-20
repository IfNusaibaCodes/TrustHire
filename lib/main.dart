import 'package:flutter/material.dart';
import 'package:trust_hire_app/Pages/landing_page.dart';
import 'package:trust_hire_app/Pages/login_page.dart';
import 'package:trust_hire_app/Pages/signup_page.dart';
import 'Pages/scam_detector_page.dart';
import 'Pages/learning_lab_page.dart';
import 'Pages/victim_stories_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VictimStoriesPage(),
    );
  }
}
