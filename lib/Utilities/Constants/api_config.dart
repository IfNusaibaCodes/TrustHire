import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

/// Configuration for the self-hosted scam-detection ML API (see ml/api/main.py).
///
/// WHY THIS FILE EXISTS
/// The Flutter app does not run the ML model itself — it sends the job text to a
/// small Python server and gets back a score. The tricky part is the URL of that
/// server differs depending on WHERE the app runs:
///
///   • Android emulator  -> 10.0.2.2  (the emulator's alias for the host PC's
///                                       localhost; "127.0.0.1" would mean the
///                                       emulator itself, not your PC)
///   • iOS simulator / desktop / web -> 127.0.0.1
///   • Physical phone    -> your PC's LAN IP, e.g. 192.168.1.42
///                          (phone and PC must be on the same Wi-Fi)
///
/// HOW TO USE
/// For emulator/simulator/desktop testing you usually need to change nothing.
/// On a physical device, set [kScamApiOverride] to `http://YOUR-PC-IP:8000`.
class ApiConfig {
  /// Port uvicorn serves on (matches `--port 8000` in the run command).
  static const int _port = 8000;

  /// Set this to force a specific base URL (needed for a physical device).
  /// Leave empty to auto-detect by platform. Example:
  ///   static const String kScamApiOverride = 'http://192.168.1.42:8000';
  static const String kScamApiOverride = '';

  /// Base URL of the scam API, chosen automatically for the current platform.
  static String get scamApiBaseUrl {
    if (kScamApiOverride.isNotEmpty) return kScamApiOverride;
    if (kIsWeb) return 'http://127.0.0.1:$_port';
    if (Platform.isAndroid) return 'http://10.0.2.2:$_port';
    return 'http://127.0.0.1:$_port'; // iOS sim, Windows, macOS, Linux
  }

  /// Full predict endpoint.
  static String get scamPredictUrl => '$scamApiBaseUrl/predict';
}
