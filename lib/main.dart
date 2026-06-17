import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Authentication/Services/deep_link_service.dart';
import 'package:trust_hire_app/Authentication/Controllers/notification_controller.dart';
import 'package:trust_hire_app/Pages/Notifications/notification_page.dart';
import 'package:trust_hire_app/Authentication/Services/push_service.dart';
import 'package:trust_hire_app/Pages/landing_page.dart';
import 'package:trust_hire_app/firebase_options.dart';
import 'package:trust_hire_app/Pages/splash_page.dart';
import 'package:trust_hire_app/Utilities/Customs/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://pgqagkfcbeifyibyyyce.supabase.co",
    anonKey: "sb_publishable_cWW8hzCCJBzF8k58wHzi8g__Wu-YDmt",
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
  );

  runApp(const MyApp());
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
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
    DeepLinkService.init();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home:  SplashPage(),
      theme: TCustomApp.customTheme,
    );
  }
}
