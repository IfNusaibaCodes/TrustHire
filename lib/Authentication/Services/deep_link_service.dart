import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Navigation/bottom_navigator.dart';

class DeepLinkService {
  static StreamSubscription? _sub;

  static void init() {
    final appLinks = AppLinks();

    // Links received while app is running
    _sub = appLinks.uriLinkStream.listen(_handleUri);

    // Link that cold-started the app
    appLinks.getInitialLink().then((uri) {
      if (uri != null) _handleUri(uri);
    });
  }

  static Future<void> _handleUri(Uri uri) async {
    final tokenHash = uri.queryParameters['token_hash'];
    final type      = uri.queryParameters['type'];
    if (tokenHash == null || type == null) return;

    final otpType = type == 'recovery' ? OtpType.recovery : OtpType.signup;
    try {
      await Supabase.instance.client.auth.verifyOTP(
        tokenHash: tokenHash,
        type: otpType,
      );
      Get.offAll(() => const BottomNavBar());
    } catch (e) {
      Get.snackbar(
        'Confirmation Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static void dispose() => _sub?.cancel();
}
