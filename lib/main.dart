import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Pages/Burnout/burnout_check_page.dart';
import 'package:trust_hire_app/Pages/Guide/work_guide_page.dart';
import 'package:trust_hire_app/Pages/Login/login_page.dart';
import 'package:trust_hire_app/Pages/landing_page.dart';
import 'package:trust_hire_app/Pages/onboarding_page.dart';
import 'package:trust_hire_app/Pages/SignUp/signup_page.dart';
import 'package:trust_hire_app/Utilities/Customs/theme.dart';
import 'package:trust_hire_app/profile/profile_page.dart';
import 'Pages/Job Feed/job_feed_page.dart';
import 'Pages/scam_detection_page.dart';
import 'Pages/burnout_check_page.dart';
import 'Pages/Planner/planner_page.dart';


import 'Pages/Drawer/about_us_page.dart';
import 'Pages/Drawer/contact_us_page.dart';
import 'Pages/Drawer/privacy_policy_page.dart';
import 'Pages/Drawer/terms_conditions_page.dart';
import 'Pages/Drawer/feedback_support_page.dart';

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

      home: FeedbackSupportPage(),

      theme: TCustomApp.customTheme,


    );
  }
}