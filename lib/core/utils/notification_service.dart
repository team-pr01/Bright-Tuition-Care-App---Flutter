import 'dart:convert';

import 'package:btcclient/features/notifications/services/notification_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService _instance =
      NotificationService._();

  factory NotificationService() => _instance;

  static final FlutterLocalNotificationsPlugin
      _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel =
      AndroidNotificationChannel(
    'bright_tuition_channel',
    'Bright Tuition Care',
    description: 'Notifications from Bright Tuition Care',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound(
      'notification',
    ),
  );

  // ============================================================
  // INITIALIZATION
  // ============================================================

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse:
          _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse:
          _onNotificationTapBackground,
    );

    await _requestPermission();

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // ==========================================================
    // FCM TOKEN
    // ==========================================================

    final token =
        await FirebaseMessaging.instance.getToken();

    debugPrint('================================');
    debugPrint('FCM TOKEN:');
    debugPrint(token);
    debugPrint('================================');

    // ==========================================================
    // FOREGROUND
    // ==========================================================

    FirebaseMessaging.onMessage.listen(
      _onForegroundMessage,
    );

    // ==========================================================
    // BACKGROUND -> USER TAPS NOTIFICATION
    // ==========================================================

    FirebaseMessaging.onMessageOpenedApp.listen(
      _onNotificationOpened,
    );

    // ==========================================================
    // TERMINATED -> USER TAPS NOTIFICATION
    // ==========================================================

    final initialMessage =
        await FirebaseMessaging.instance
            .getInitialMessage();

    if (initialMessage != null) {
      debugPrint(
        '📨 App opened from terminated notification',
      );

      _handleNotificationData(
        initialMessage.data,
      );
    }
  }

  // ============================================================
  // PERMISSION
  // ============================================================

  Future<void> _requestPermission() async {
    final settings =
        await FirebaseMessaging.instance
            .requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      '🔔 Notification Permission: '
      '${settings.authorizationStatus}',
    );
  }

  // ============================================================
  // FOREGROUND FCM
  // ============================================================

  void _onForegroundMessage(
    RemoteMessage message,
  ) {
    debugPrint(
      '📨 Foreground notification received',
    );

    debugPrint(
      'Message ID: ${message.messageId}',
    );

    debugPrint(
      'Notification Data: ${message.data}',
    );

    // Show notification in system tray.
    _showLocalNotification(message);
  }

  // ============================================================
  // BACKGROUND FCM -> NOTIFICATION TAP
  // ============================================================

  void _onNotificationOpened(
    RemoteMessage message,
  ) {
    debugPrint(
      '🔔 Background notification clicked',
    );

    debugPrint(
      'Notification Data: ${message.data}',
    );

    _handleNotificationData(
      message.data,
    );
  }

  // ============================================================
  // GENERIC NOTIFICATION HANDLER
  // ============================================================

  static void handleNotification(
    Map<String, dynamic> data,
  ) {
    debugPrint(
      '🔔 Handle notification: $data',
    );

    NotificationRouter.handleNotification(
      data,
    );
  }

  // ============================================================
  // HANDLE FCM DATA
  // ============================================================

  void _handleNotificationData(
    Map<String, dynamic> data,
  ) {
    debugPrint(
      '🔔 FCM notification data: $data',
    );

    handleNotification(data);
  }

  // ============================================================
  // SHOW LOCAL NOTIFICATION
  // ============================================================

  Future<void> _showLocalNotification(
    RemoteMessage message,
  ) async {
    final notification =
        message.notification;

    if (notification == null) {
      debugPrint(
        '⚠️ FCM message has no notification payload',
      );

      return;
    }

    final android =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription:
          channel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const ios =
        DarwinNotificationDetails();

    // ----------------------------------------------------------
    // IMPORTANT:
    //
    // We store the ENTIRE notification data
    // instead of only jobId/deepLink.
    //
    // This allows every future notification type
    // to be routed correctly.
    // ----------------------------------------------------------

    final payload =
        jsonEncode(message.data);

    await _localNotifications.show(
      DateTime.now()
          .millisecondsSinceEpoch ~/
          1000,
      notification.title,
      notification.body,
      NotificationDetails(
        android: android,
        iOS: ios,
      ),
      payload: payload,
    );
  }

  // ============================================================
  // LOCAL NOTIFICATION TAP
  // ============================================================

  static void _onNotificationTap(
    NotificationResponse response,
  ) {
    debugPrint(
      '🔔 Local notification clicked',
    );

    _handlePayload(
      response.payload,
    );
  }

  // ============================================================
  // LOCAL NOTIFICATION BACKGROUND TAP
  // ============================================================

  @pragma('vm:entry-point')
  static void _onNotificationTapBackground(
    NotificationResponse response,
  ) {
    debugPrint(
      '🔔 Background local notification clicked',
    );

    _handlePayload(
      response.payload,
    );
  }

  // ============================================================
  // HANDLE LOCAL NOTIFICATION PAYLOAD
  // ============================================================

  static void _handlePayload(
    String? payload,
  ) {
    if (payload == null ||
        payload.isEmpty) {
      debugPrint(
        '⚠️ Notification payload is empty',
      );

      return;
    }

    try {
      final decoded =
          jsonDecode(payload);

      if (decoded is Map) {
        final data =
            Map<String, dynamic>.from(
          decoded,
        );

        debugPrint(
          '🔔 Local notification data: $data',
        );

        handleNotification(data);

        return;
      }

      debugPrint(
        '⚠️ Invalid notification payload',
      );
    } catch (e) {
      debugPrint(
        '❌ Failed to decode notification '
        'payload: $e',
      );
    }
  }
}