import 'package:btcclient/features/auth/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorDashboardScreen extends ConsumerWidget {

  const TutorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(authProvider).user;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Tutor Dashboard"),

        actions: [

          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () async {

              await ref
                  .read(authProvider.notifier)
                  .logout();

              Navigator.pushNamedAndRemoveUntil(
                context,
                "/login",
                (route) => false,
              );

            },
          )

        ],
      ),

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.school,
              size: 80,
              color: Colors.blue,
            ),

            const SizedBox(height: 16),

            Text(
              "Welcome Tutor ${user?.name ?? "Guest"}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              user?.email ?? "",
              style: const TextStyle(fontSize: 16),
            ),

          ],

        ),

      ),

    );

  }

}