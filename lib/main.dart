import 'dart:async';

import 'package:btcclient/app.dart';
import 'package:btcclient/core/utils/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

/// Background FCM Handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint("📨 Background message received");
  debugPrint("Message ID: ${message.messageId}");
  debugPrint("Data: ${message.data}");

  // Don't navigate here.
  // We'll handle notification taps when the app opens.
}

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    /// Load .env
    await dotenv.load(fileName: ".env");

    /// Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint("✅ Firebase initialized");

    /// Register background handler
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );

    /// Initialize Notification Service
    final notificationService = NotificationService();
    await notificationService.init();

    debugPrint("✅ Notification Service initialized");

    /// Initialize Deep Link Service
    // final deepLinkService = DeepLinkService();
    // await deepLinkService.init();

    debugPrint("✅ Deep Link Service initialized");

    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  }, (error, stackTrace) {
    debugPrint("❌ Unhandled Error: $error");

    if (kDebugMode) {
      debugPrintStack(stackTrace: stackTrace);
    }
  });
}