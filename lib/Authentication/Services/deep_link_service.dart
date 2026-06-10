import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Navigation/bottom_navigator.dart';
import 'package:trust_hire_app/Pages/Login/reset_password_page.dart';

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
      if (data.event == AuthChangeEvent.passwordRecovery) {
        // Reset password link tapped — go to set-new-password screen
        Get.offAll(() => const ResetPasswordPage());
      } else if (data.event == AuthChangeEvent.signedIn && _fromDeepLink) {
        // Email confirmation link tapped — go to home
        _fromDeepLink = false;
        Get.offAll(() => const BottomNavBar());
      }
    });
  }

  static bool _isAuthUri(Uri uri) =>
      uri.queryParameters.containsKey('code') ||
      uri.queryParameters.containsKey('token_hash') ||
      uri.fragment.contains('access_token');

  static void dispose() {
    _linkSub?.cancel();
    _authSub?.cancel();
  }
}
