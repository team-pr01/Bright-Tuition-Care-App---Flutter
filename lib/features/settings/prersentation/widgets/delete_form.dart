 import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/settings/prersentation/widgets/card_wrapper.dart';
import 'package:btcclient/features/settings/prersentation/widgets/show_delete_dialog.dart';
import 'package:flutter/material.dart';

Widget deleteForm( BuildContext context,ThemeData theme) {
    return cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delete Account",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.backgroundDark,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            "Are you sure you want to delete your account? This action cannot be undone. Please proceed with caution.",
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.neutrals02),
          ),

          const SizedBox(height: AppSpacing.lg),

          /// CTA
          AppButton(
            label: "Delete Account",
            variant: AppButtonVariant.delete,
            onPressed: () {
              showDeleteDialog(context);
            },
          ),
        ],
      ),
    );
  }