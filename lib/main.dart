import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Pages/job_feed.dart';
import 'package:trust_hire_app/Pages/Login/login_page.dart';
import 'package:trust_hire_app/Pages/onboarding_page.dart';
import 'package:trust_hire_app/Pages/SignUp/signup_page.dart';
import 'package:trust_hire_app/Utilities/theme/theme.dart';

import 'Pages/scam_detection_page.dart';

void main() async{
  await Supabase.initialize(
      url: "https://pgqagkfcbeifyibyyyce.supabase.co",
      anonKey: "sb_publishable_cWW8hzCCJBzF8k58wHzi8g__Wu-YDmt"
  );



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SignUpPage(),

      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
    );
  }
}
