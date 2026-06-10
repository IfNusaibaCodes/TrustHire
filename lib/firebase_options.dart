// Firebase options for TrustHire.
//
// Hand-written from android/app/google-services.json (Android platform only).
// If you regenerate google-services.json (e.g. new app / rotated key), update
// the Android values below to match.
//
// Note: these client config values (apiKey, appId, etc.) are designed to be
// embedded in the app and are safe to commit — they are not secrets. The real
// secret is the FCM service-account JSON, which stays git-ignored.
//
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not configured for web - '
        'only Android is configured.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for $defaultTargetPlatform - '
          'only Android is configured.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBLG4i5_dr_T5QXC84I_fprSBybb-dIQ_A',
    appId: '1:481924236654:android:38754b2b73cff126e16d7f',
    messagingSenderId: '481924236654',
    projectId: 'trusthire-1e239',
    storageBucket: 'trusthire-1e239.firebasestorage.app',
  );
}
