import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';

Widget verificationStatusCard(
  ThemeData theme,
  bool isVerified,
  bool hasRequested,
) {
  final Color bgColor = isVerified
      ? Colors.green.withOpacity(0.08)
      : hasRequested
          ? AppColors.primary01.withOpacity(0.08)
          : AppColors.neutrals04;

  final Color iconColor = isVerified
      ? Colors.green
      : hasRequested
          ? AppColors.primary01
          : AppColors.neutrals03;

  final IconData icon = isVerified
      ? Icons.verified
      : hasRequested
          ? Icons.hourglass_top
          : Icons.info_outline;

  return Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      border: Border.all(
        color: bgColor.withOpacity(0.5),
      ),
    ),
    child: Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            isVerified
                ? "Verification completed successfully"
                : hasRequested
                    ? "Your verification request is under review"
                    : "You have not requested verification yet",
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    ),
  );
}