import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

void main() {
  runZonedGuarded(() async {

    WidgetsFlutterBinding.ensureInitialized();

    /// Load environment variables (.env)
    await dotenv.load(fileName: ".env");

    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );

  }, (error, stack) {

    debugPrint("GLOBAL ERROR: $error");
    debugPrintStack(stackTrace: stack);

  });
}