import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/settings/prersentation/widgets/card_wrapper.dart';
import 'package:btcclient/features/settings/prersentation/widgets/show_unlock_model.dart';
import 'package:flutter/material.dart';

Widget lockForm( BuildContext context,ThemeData theme, bool isProfileLocked) {
    return cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Profile Status", style: theme.textTheme.headlineSmall),

          const SizedBox(height: AppSpacing.md),

          Text(
            isProfileLocked
                ? "Your profile is now locked and you can't edit it until you unlock it."
                : "Your profile is now unlocked and you can edit it whenever you want.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.neutrals03,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          /// CTA Button (ONLY ONE like React version)
          AppButton(
            variant: AppButtonVariant.gradient,
            label: isProfileLocked ? "Unlock Profile" : "Edit Profile",
            onPressed: () {
              if (isProfileLocked) {
                showUnlockModal(context);
              } else {
                // ✏️ Navigate to edit profile screen
              }
            },
          ),
        ],
      ),
    );
  }

  