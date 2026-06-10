import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Navigation/bottom_navigator.dart';
import 'package:trust_hire_app/Pages/Login/reset_password_page.dart';
import 'package:trust_hire_app/Pages/Notifications/push_service.dart';

class DeepLinkService {
  static StreamSubscription? _linkSub;
  static StreamSubscription? _authSub;
  static bool _fromDeepLink = false;

  static void init() {
    final appLinks = AppLinks();

    // Mark when a deep link arrives so we can distinguish
    // deep-link sign-ins from regular password sign-ins
    _linkSub = appLinks.uriLinkStream.listen((uri) {
      if (_isAuthUri(uri)) _fromDeepLink = true;
    });
    appLinks.getInitialLink().then((uri) {
      if (uri != null && _isAuthUri(uri)) _fromDeepLink = true;
    });

    // supabase_flutter processes the token/code automatically.
    // We only need to react to the resulting auth event for navigation.
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      // Keep this device's FCM push token in sync with the auth session.
      // initialSession covers users already logged in when the app launches.
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.initialSession) {
        final uid = data.session?.user.id;
        if (uid != null) PushService.registerToken(uid);
      } else if (event == AuthChangeEvent.signedOut) {
        PushService.unregisterToken();
      }

      if (event == AuthChangeEvent.passwordRecovery) {
        // Reset password link tapped — go to set-new-password screen
        Get.offAll(() => const ResetPasswordPage());
      } else if (event == AuthChangeEvent.signedIn && _fromDeepLink) {
        // Email confirmation link tapped — go to home
        _fromDeepLink = false;
        Get.offAll(() => const BottomNavBar());
      }
    });
  }

  static bool _isAuthUri(Uri uri) =>
      uri.queryParameters.containsKey('code') ||
      uri.queryParameters.containsKey('token_hash') ||
      uri.fragment.contains('access_token') ||
      uri.fragment.contains('error_code');

  static void dispose() {
    _linkSub?.cancel();
    _authSub?.cancel();
  }
}
