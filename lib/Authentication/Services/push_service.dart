import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Background isolate handler for FCM messages.
///
/// Must be a top-level function annotated with `vm:entry-point` so it survives
/// tree-shaking in the background/terminated isolate.
///
/// When the app is backgrounded or terminated, Android draws FCM `notification`
/// messages in the system tray automatically (via the channel referenced by the
/// manifest's `default_notification_channel_id`). So there is nothing to draw
/// here — this exists to satisfy the FCM background contract and is where
/// data-only handling would go if added later. Do NOT touch UI from here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Intentionally minimal.
}

/// The single layer that talks to firebase_messaging + flutter_local_notifications.
/// Nothing else in the app should import those packages directly.
///
/// Mirrors the static-service / `init()`-in-main pattern used by
/// [DeepLinkService].
class PushService {
  PushService._();

  static final _client = Supabase.instance.client;
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  // Must stay in sync with the <meta-data> default_notification_channel_id in
  // AndroidManifest.xml. HIGH importance is what makes the banner "pop".
  static const _channelId = 'high_importance_channel';
  static const _channelName = 'High Importance Notifications';
  static const _channelDesc =
      'Used for important TrustHire alerts and announcements.';

  /// Wired up in `main()`: given a tapped notification's data payload, navigate
  /// to the notifications screen. Kept as a callback so this service stays free
  /// of routing / widget imports.
  static void Function(Map<String, dynamic> data)? onNotificationTap;

  static StreamSubscription<String>? _tokenRefreshSub;

  // ── Init ──────────────────────────────────────────────────────────────────
  static Future<void> init() async {
    // 1. flutter_local_notifications + a HIGH-importance channel.
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          _route(_decode(payload));
        }
      },
    );

    final androidImpl = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
      ),
    );

    // 2. Permission (Android 13+ POST_NOTIFICATIONS + iOS prompt).
    await FirebaseMessaging.instance.requestPermission();
    await androidImpl?.requestNotificationsPermission();

    // 3. Background handler.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 4. Foreground: Android does NOT auto-display FCM notifications while the
    //    app is open, so draw a local heads-up banner ourselves.
    FirebaseMessaging.onMessage.listen(_showLocal);

    // 5. Taps: app in background → resume and route; app terminated → route
    //    once the first frame (and the GetMaterialApp navigator) is ready.
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _route(m.data));
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _route(initial.data));
    }
  }

  // ── Foreground banner ───────────────────────────────────────────────────────
  static void _showLocal(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _local.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  static void _route(Map<String, dynamic> data) => onNotificationTap?.call(data);

  static Map<String, dynamic> _decode(String payload) {
    try {
      final decoded = jsonDecode(payload);
      return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  // ── Token registration ──────────────────────────────────────────────────────
  /// Call on sign-in. Stores this device's FCM token against [userId] and keeps
  /// it fresh when FCM rotates it.
  static Future<void> registerToken(String userId) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _upsertToken(userId, token);

      await _tokenRefreshSub?.cancel();
      _tokenRefreshSub =
          FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        // Re-read the current uid in case the session changed mid-stream.
        final uid = _client.auth.currentUser?.id ?? userId;
        _upsertToken(uid, newToken);
      });
    } catch (e) {
      // Best-effort: Firebase may not be ready yet, or the network is down.
      // The auth listener retries on the next sign-in / app launch.
      debugPrint('registerToken failed: $e');
    }
  }

  static Future<void> _upsertToken(String userId, String token) async {
    await _client.from('device_tokens').upsert(
      {
        'token': token,
        'user_id': userId,
        'platform': defaultTargetPlatform.name,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
      onConflict: 'token',
    );
  }

  /// Call on sign-out. Removes this device's token row and clears the local FCM
  /// token so the signed-out user stops receiving pushes on this device.
  ///
  /// Note: Supabase emits `signedOut` *after* the session is cleared, so the
  /// RLS-protected DELETE may affect 0 rows (auth.uid() is already null). That
  /// is fine — `deleteToken()` invalidates the token, and the send-push Edge
  /// Function prunes the now-stale row server-side on the next broadcast (404).
  static Future<void> unregisterToken() async {
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _client.from('device_tokens').delete().eq('token', token);
      }
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {
      // Best-effort cleanup during sign-out; ignore failures.
    }
  }
}
