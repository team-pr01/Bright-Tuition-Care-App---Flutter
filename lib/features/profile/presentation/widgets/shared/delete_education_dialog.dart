import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import 'package:flutter/material.dart';

Future<bool?> showDeleteEducationDialog(
  BuildContext context,
) {
  final theme = Theme.of(context);

  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return ReusableBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: AppSpacing.sm,
            ),

            /// ICON
            Container(
              padding: const EdgeInsets.all(
                AppSpacing.md,
              ),
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

            const SizedBox(
              height: AppSpacing.md,
            ),

            /// TITLE
            Text(
              "Delete Education",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: AppSpacing.sm,
            ),

            /// DESCRIPTION
            Text(
              "Are you sure you want to delete this education record? "
              "This action cannot be undone.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.neutrals03,
              ),
            ),

            const SizedBox(
              height: AppSpacing.lg,
            ),

            /// BUTTONS
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: "Cancel",
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),

                const SizedBox(
                  width: AppSpacing.sm,
                ),

                Expanded(
                  child: AppButton(
                    label: "Delete",
                    variant: AppButtonVariant.delete,
                    onPressed: () {
                      Navigator.pop(context, true);
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