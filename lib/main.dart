import 'dart:async';

import 'package:btcclient/core/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

import 'app.dart';

// ✅ Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final notificationService = NotificationService();
  await notificationService.init();
  
  print('📨 Background message received: ${message.messageId}');
}

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    /// Load environment variables (.env)
    await dotenv.load(fileName: ".env");

    // ✅ Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');

    // ✅ Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    print('✅ Background message handler set');

    // ✅ Initialize Notification Service
    final notificationService = NotificationService();
    await notificationService.init();
    print('✅ Notification service initialized');

    runApp(
      const ProviderScope(
        child: MyApp(), // ✅ This is your actual app from app.dart
      ),
    );

  }, (error, stack) {
    debugPrint("GLOBAL ERROR: $error");
    debugPrintStack(stackTrace: stack);
  });
}