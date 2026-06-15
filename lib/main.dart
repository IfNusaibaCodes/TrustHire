import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Authentication/Services/deep_link_service.dart';
import 'package:trust_hire_app/Pages/Notifications/notification_controller.dart';
import 'package:trust_hire_app/Pages/Notifications/notification_page.dart';
import 'package:trust_hire_app/Pages/Notifications/push_service.dart';
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

  // Defer heavy startup work until AFTER the first frame so the UI appears
  // immediately. Blocking the first frame on Firebase + FCM init (it spins up a
  // background engine and hits the network) caused a cold-start ANR on slower /
  // aggressive-OEM devices, which the OS resolves by killing the app
  // ("Lost connection to device"). Firebase is initialized before
  // DeepLinkService so the auth listener can register the push token safely.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
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
    DeepLinkService.init();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home:  LandingPage(),
      theme: TCustomApp.customTheme,
    );
  }
}
