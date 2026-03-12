import 'package:flutter/material.dart';

enum SnackType { success, error, warning }

class AppSnackbar {
  static void show(
    BuildContext context,
    String message,
    SnackType type,
  ) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        
        break;

      case SnackType.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;

      case SnackType.warning:
        backgroundColor = const Color.fromARGB(255, 245, 167, 51);
        icon = Icons.warning;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor.withOpacity(0.5),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: backgroundColor),
        ),
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}