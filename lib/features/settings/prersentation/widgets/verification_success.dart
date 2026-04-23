import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

Widget verificationSuccess(ThemeData theme) {
  return Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: Colors.green.withOpacity(0.05),
      borderRadius: BorderRadius.circular(AppRadius.large),
    ),
    child: Column(
      children: [
        const Icon(Icons.verified, size: 60, color: Colors.green),

        const SizedBox(height: AppSpacing.md),

        Text("Verification Complete",
            style: theme.textTheme.headlineSmall),

        const SizedBox(height: AppSpacing.sm),

        Text(
          "Your profile has been successfully verified",
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}