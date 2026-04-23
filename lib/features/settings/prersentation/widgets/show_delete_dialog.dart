import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import 'package:flutter/material.dart';

void showDeleteDialog(BuildContext context) {
  final TextEditingController reasonController = TextEditingController();
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return ReusableBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.sm),

            /// ICON
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                size: 40,
                color: AppColors.error,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            /// TITLE
            Text(
              "Delete Account",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.error,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            /// TEXT
            Text(
              "It’s sad to see you go. Are you sure you want to delete your account?",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.neutrals03,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            /// INPUT
            AppInputField(
              label: "Reason for account deletion (Optional)",
              hint: "Please enter reason ...",
              controller: reasonController,
              type: AppInputType.multiline,
              maxLines: 4,
            ),

            const SizedBox(height: AppSpacing.lg),

            /// BUTTONS
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: "Cancel",
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    label: "Delete",
                    variant: AppButtonVariant.delete,
                    onPressed: () {
                      Navigator.pop(context);

                      final reason = reasonController.text.trim();
                      print("Delete reason: $reason");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}