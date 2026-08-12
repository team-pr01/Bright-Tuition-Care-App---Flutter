import 'dart:convert';

import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/features/notifications/services/notification_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();

  factory NotificationService() => _instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  VoidCallback? onNotificationReceived;

  static const AndroidNotificationChannel channel =
      AndroidNotificationChannel(
    'bright_tuition_channel',
    'Bright Tuition Care',
    description: 'Notifications from Bright Tuition Care',
    importance: Importance.max,
    playSound: true,
    // IMPORTANT:
    // Remove this temporarily unless you have:
    // android/app/src/main/res/raw/notification.mp3
    //
    // sound: RawResourceAndroidNotificationSound('notification'),
  );

  bool _initialized = false;

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> init() async {
    if (_initialized) {
      debugPrint('🔔 NotificationService already initialized');
      return;
    }

    debugPrint('🔔 Initializing NotificationService...');

    // ----------------------------------------------------------
    // LOCAL NOTIFICATIONS
    // ----------------------------------------------------------

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
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
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse:
          _onNotificationTapBackground,
    );

    debugPrint('✅ Local notifications initialized');

    // ----------------------------------------------------------
    // PERMISSION
    // ----------------------------------------------------------

    await _requestPermission();

    // ----------------------------------------------------------
    // ANDROID CHANNEL
    // ----------------------------------------------------------

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);

    debugPrint('✅ Notification channel created');

    // ----------------------------------------------------------
    // FCM TOKEN
    // ----------------------------------------------------------

    await registerFcmToken();

    // ----------------------------------------------------------
    // TOKEN REFRESH
    // ----------------------------------------------------------

    FirebaseMessaging.instance.onTokenRefresh.listen(
      (newToken) async {
        try {
          debugPrint('🔄 FCM token refreshed');
          debugPrint(newToken);

          await LocalStorage.saveFcmToken(newToken);

          await _sendTokenToBackend(newToken);
        } catch (e, stackTrace) {
          debugPrint('❌ Failed handling token refresh: $e');
          debugPrintStack(stackTrace: stackTrace);
        }
      },
    );

    // ----------------------------------------------------------
    // FOREGROUND
    // ----------------------------------------------------------

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        await _onForegroundMessage(message);
      },
    );

    // ----------------------------------------------------------
    // BACKGROUND → TAP
    // ----------------------------------------------------------

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint('🔔 Background notification opened');
        debugPrint('🔔 Data: ${message.data}');

        _handleNotificationData(message.data);
      },
    );

    // ----------------------------------------------------------
    // TERMINATED → TAP
    // ----------------------------------------------------------

    final initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('📨 App opened from terminated notification');
      debugPrint('📨 Data: ${initialMessage.data}');

      _handleNotificationData(initialMessage.data);
    }

    _initialized = true;

    debugPrint('✅ NotificationService initialization completed');
  }

  // ============================================================
  // PERMISSION
  // ============================================================

  Future<void> _requestPermission() async {
    try {
      final settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint(
        '🔔 Notification permission: '
        '${settings.authorizationStatus}',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Notification permission error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  // ============================================================
  // FCM TOKEN REGISTRATION
  // ============================================================

  Future<void> registerFcmToken() async {
    try {
      debugPrint('🔥 Getting FCM token...');

      final token = await FirebaseMessaging.instance.getToken();

      if (token == null || token.isEmpty) {
        debugPrint('❌ FCM token is NULL / EMPTY');
        return;
      }

      debugPrint('======================================');
      debugPrint('🔥 FCM TOKEN');
      debugPrint(token);
      debugPrint('======================================');

      await LocalStorage.saveFcmToken(token);

      debugPrint('💾 FCM token saved locally');

      final accessToken = await LocalStorage.getToken();

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint(
          '⚠️ No access token yet. '
          'FCM token will be sent after login.',
        );
        return;
      }

      await _sendTokenToBackend(token);
    } catch (e, stackTrace) {
      debugPrint('❌ FCM token registration failed: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  // ============================================================
  // SEND TOKEN TO BACKEND
  // ============================================================

  Future<void> _sendTokenToBackend(String token) async {
    try {
      final accessToken = await LocalStorage.getToken();

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint(
          '⚠️ Cannot send FCM token: user is not authenticated',
        );
        return;
      }

      debugPrint('📤 Sending FCM token to backend...');

      final response = await http.patch(
        Uri.parse(
          'https://bright-tuition-care-server.onrender.com'
          '/api/v1/auth/save-push-token',
        ),
        headers: {
          'Authorization': accessToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pushToken': token,
        }),
      );

      debugPrint(
        '📤 FCM backend status: ${response.statusCode}',
      );

      debugPrint(
        '📤 FCM backend response: ${response.body}',
      );

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        debugPrint(
          '✅ FCM TOKEN REGISTERED SUCCESSFULLY',
        );
      } else {
        debugPrint(
          '❌ FCM TOKEN REGISTRATION FAILED',
        );
      }
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Error sending FCM token to backend: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }
  }

  // ============================================================
  // FOREGROUND MESSAGE
  // ============================================================

  Future<void> _onForegroundMessage(
    RemoteMessage message,
  ) async {
    debugPrint('');
    debugPrint('🔥🔥🔥 FCM MESSAGE RECEIVED 🔥🔥🔥');
    debugPrint('🔥 Message ID: ${message.messageId}');
    debugPrint(
      '🔥 Title: ${message.notification?.title}',
    );
    debugPrint(
      '🔥 Body: ${message.notification?.body}',
    );
    debugPrint(
      '🔥 Data: ${message.data}',
    );
    debugPrint('');

    try {
      await _showLocalNotification(message);
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Failed to show foreground notification: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }

    onNotificationReceived?.call();
  }

  // ============================================================
  // SHOW LOCAL NOTIFICATION
  // ============================================================

  Future<void> _showLocalNotification(
    RemoteMessage message,
  ) async {
    final notification = message.notification;

    if (notification == null) {
      debugPrint(
        '⚠️ Message contains no notification payload.',
      );

      debugPrint(
        '⚠️ This appears to be a DATA-ONLY FCM message.',
      );

      return;
    }

    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final payload = jsonEncode(message.data);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification.title ?? 'Bright Tuition Care',
      notification.body ?? '',
      NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: payload,
    );

    debugPrint('✅ Foreground local notification displayed');
  }

  // ============================================================
  // FCM NOTIFICATION DATA
  // ============================================================

  void _handleNotificationData(
    Map<String, dynamic> data,
  ) {
    debugPrint(
      '🔔 Handling notification data: $data',
    );

    handleNotification(data);
  }

  // ============================================================
  // ROUTER
  // ============================================================

  static void handleNotification(
    Map<String, dynamic> data,
  ) {
    debugPrint(
      '🔔 NotificationRouter → $data',
    );

    NotificationRouter.handleNotification(data);
  }

  // ============================================================
  // LOCAL NOTIFICATION TAP
  // ============================================================

  static void _onNotificationTap(
    NotificationResponse response,
  ) {
    debugPrint('🔔 Local notification tapped');

    _handlePayload(response.payload);
  }

  // ============================================================
  // BACKGROUND LOCAL NOTIFICATION TAP
  // ============================================================

  @pragma('vm:entry-point')
  static void _onNotificationTapBackground(
    NotificationResponse response,
  ) {
    debugPrint(
      '🔔 Background local notification tapped',
    );

    _handlePayload(response.payload);
  }

  // ============================================================
  // LOCAL PAYLOAD
  // ============================================================

  static void _handlePayload(
    String? payload,
  ) {
    if (payload == null || payload.isEmpty) {
      debugPrint(
        '⚠️ Local notification payload is empty',
      );
      return;
    }

    try {
      final decoded = jsonDecode(payload);

      if (decoded is! Map) {
        debugPrint(
          '⚠️ Invalid notification payload',
        );
        return;
      }

      final data = Map<String, dynamic>.from(decoded);

      debugPrint(
        '🔔 Local notification data: $data',
      );

      handleNotification(data);
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Failed to decode notification payload: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }
  }
}