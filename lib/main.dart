import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Authentication/Services/deep_link_service.dart';
import 'package:trust_hire_app/Pages/Notifications/notification_controller.dart';
import 'package:trust_hire_app/Pages/Notifications/notification_page.dart';
import 'package:trust_hire_app/Pages/Notifications/push_service.dart';
import 'package:trust_hire_app/firebase_options.dart';
import 'package:trust_hire_app/Pages/Burnout/burnout_check_page.dart';
import 'package:trust_hire_app/Pages/Growth/growth_page.dart';
import 'package:trust_hire_app/Pages/Guide/work_guide_page.dart';
import 'package:trust_hire_app/Pages/Job%20Feed/all_jobs.dart';
import 'package:trust_hire_app/Pages/Login/login_page.dart';
import 'package:trust_hire_app/Pages/landing_page.dart';
import 'package:trust_hire_app/Pages/onboarding_page.dart';
import 'package:trust_hire_app/Pages/SignUp/signup_page.dart';
import 'package:trust_hire_app/Utilities/Customs/theme.dart';
import 'package:trust_hire_app/profile/profile_page.dart';
import 'Pages/Job Feed/job_feed_page.dart';
import 'Pages/Planner/planner_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://pgqagkfcbeifyibyyyce.supabase.co",
    anonKey: "sb_publishable_cWW8hzCCJBzF8k58wHzi8g__Wu-YDmt",
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
  );

  // Firebase + push notifications. Wrapped so a placeholder firebase_options.dart
  // (before you run `flutterfire configure`) can't brick app launch — the rest
  // of the app still works, push just stays off until Firebase is configured.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Tapping a push routes to the notifications screen (GetX nav). Ensure the
    // controller exists in case the app was launched cold from a notification.
    PushService.onNotificationTap = (data) {
      if (!Get.isRegistered<NotificationController>()) {
        Get.put(NotificationController());
      }
      Get.to(() => const NotificationPage());
    };
    await PushService.init();
  } catch (e, st) {
    debugPrint('Push notifications init skipped: $e\n$st');
  }

  runApp(const MyApp());
  DeepLinkService.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LandingPage(),
      theme: TCustomApp.customTheme,
    );
  }
}
