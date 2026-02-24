import 'package:btcclient/features/auth/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuardianDashboardScreen extends ConsumerWidget {

  const GuardianDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Guardian Dashboard"),

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

      body: const Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              Icons.person,
              size: 80,
              color: Colors.green,
            ),

            SizedBox(height: 16),

            Text(
              "Welcome Guardian",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "This is Guardian Dashboard",
              style: TextStyle(fontSize: 16),
            ),

          ],
        ),

      ),

    );

  }
}