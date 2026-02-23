import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/local_storage.dart';
import '../routing/app_start_provider.dart';

class DevResetButton extends ConsumerWidget {
  const DevResetButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: const Color.fromARGB(74, 82, 81, 81),
        onPressed: () async {
          await LocalStorage.clearWelcome();

          // ref.read(appStartProvider.notifier).goToLogin();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Welcome reset (Dev Mode)"),
            ),
          );
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
