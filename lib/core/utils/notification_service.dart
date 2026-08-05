// lib/services/notification_service.dart
import 'package:btcclient/core/storage/local_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  // Singleton pattern - only one instance exists
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Firebase Messaging instance
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Local notifications plugin (for showing notifications in foreground)
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // API URL - Change this to your backend URL
  final String _apiUrl =
      'https://bright-tuition-care-server.onrender.com/api/v1';
  // Or for local development: http://localhost:5000/api/v1

  // This method initializes everything
  Future<void> init() async {
    // 1. Initialize local notifications
    await _initializeLocalNotifications();

    // 2. Request permission from user
    await _requestPermissions();

    // 3. Get and save FCM token
    await _setupFCM();

    // 4. Setup notification listeners
    _setupListeners();
  }

  // Step 1: Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    // Android settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    // Combine settings
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize
    await _localNotifications.initialize(settings);
    print('✅ Local notifications initialized');
  }

  // Step 2: Request permission
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true, // Show alert
      badge: true, // Show badge on app icon
      sound: true, // Play sound
      provisional: false, // Don't allow provisional permission
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notification permission granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('✅ Provisional notification permission granted');
    } else {
      print('❌ Notification permission denied');
    }
  }

  // Step 3: Setup FCM and get token
  Future<void> _setupFCM() async {
    // Get the device token
    String? token = await _messaging.getToken();

    if (token != null) {
      print('📱 FCM Token: $token');

      // Save token locally
      await _saveTokenToLocalStorage(token);

      // Send token to your backend
      await _sendTokenToBackend(token);
    }

    // Listen for token refresh (when token changes)
    _messaging.onTokenRefresh.listen((newToken) {
      print('🔄 FCM Token refreshed: $newToken');
      _sendTokenToBackend(newToken);
    });
  }

  // Step 4: Send token to your backend
  Future<void> _sendTokenToBackend(String token) async {
    try {
      // Get the user's auth token from storage
      final accessToken = await LocalStorage.getToken();

      if (accessToken == null || accessToken.isEmpty) {
        print('⚠️ User not logged in, cannot send FCM token');
        return;
      }

      final response = await http.patch(
        Uri.parse('$_apiUrl/auth/save-push-token'),
        headers: {
          'Authorization': accessToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pushToken': token, // This matches your backend's field name
        }),
      );

      if (response.statusCode == 200) {
        print('✅ FCM token sent to backend successfully');
      } else {
        print('❌ Failed to send token to backend: ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending token to backend: $e');
    }
  }

  // Save token locally
  Future<void> _saveTokenToLocalStorage(String token) async {
    await LocalStorage.saveFcmToken(token);
    print('💾 FCM token saved locally');
  }

  // lib/services/notification_service.dart
  // Add this method to your existing NotificationService class

  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'Channel for test notifications',
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      '🎉 Test Notification',
      'This is a test notification from your app!',
      details,
    );
  }

  // Step 5: Setup notification listeners
  void _setupListeners() {
    // When app is in FOREGROUND (user is using the app)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 Foreground message received');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');

      // Show local notification
      _showLocalNotification(message);
    });

    // When app is opened from a notification (background or terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📱 App opened from notification');
      _handleNavigation(message);
    });
  }

  // Show notification when app is in foreground
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'main_channel', // Channel ID
          'Main Notifications', // Channel Name
          channelDescription: 'Notifications from the app',
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond, // Unique ID
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      details,
      payload: jsonEncode(message.data), // Pass data for navigation
    );
  }

  // Navigate when user taps notification
  void _handleNavigation(RemoteMessage message) {
    // Get data from notification
    final data = message.data;
    final screen = data['screen']; // e.g., 'orders', 'messages', etc.
    final id = data['id']; // e.g., order ID, message ID

    print('📱 Navigate to: $screen with ID: $id');

    // You can use Provider or GetX to navigate here
    // For now, we'll just print it
  }

  // Background handler (when app is terminated)
  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    print('📨 Background message received');
    // Firebase is already initialized in background
    // Do any background processing here
  }
}
