import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Load environment variables (.env)
  await dotenv.load(fileName: ".env");

  /// Catch global errors (important for production)
  runZonedGuarded(() {

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