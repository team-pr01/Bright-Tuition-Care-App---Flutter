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

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint('📨 BACKGROUND FCM RECEIVED');
    debugPrint('📨 Message ID: ${message.messageId}');
    debugPrint('📨 Notification: ${message.notification}');
    debugPrint('📨 Data: ${message.data}');
  } catch (e, stackTrace) {
    debugPrint(
      '❌ Background FCM handler error: $e',
    );

    debugPrintStack(
      stackTrace: stackTrace,
    );
  }
}

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(
        fileName: '.env',
      );

      // ========================================================
      // FIREBASE
      // ========================================================

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      debugPrint('✅ Firebase initialized');

      // MUST be registered before runApp.
      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );

      debugPrint(
        '✅ Firebase background handler registered',
      );

      // ========================================================
      // NOTIFICATIONS
      // ========================================================

      await NotificationService().init();

      debugPrint(
        '✅ Notification service initialized',
      );

      // ========================================================
      // APP
      // ========================================================

      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      debugPrint(
        '❌ Unhandled application error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    },
  );
}