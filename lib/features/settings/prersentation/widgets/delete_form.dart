import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/settings/prersentation/widgets/card_wrapper.dart';
import 'package:btcclient/features/settings/prersentation/widgets/show_delete_dialog.dart';
import 'package:flutter/material.dart';

Widget deleteForm(BuildContext context, ThemeData theme) {
  return cardWrapper(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ================= HEADER =================
        Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: AppColors.error02.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: AppColors.error02,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delete Account",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.backgroundDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Permanent & irreversible action",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.error02,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        /// ================= DESCRIPTION =================
        Text(
          "Are you sure you want to delete your account? This action cannot be undone. Please proceed with caution.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.neutrals02,
            height: 1.5,
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        /// ================= DELETION POINTERS =================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.error02.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.error02.withOpacity(0.18),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "If you delete your account, the following will be permanently removed:",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.backgroundDark,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              _deletePointer(
                theme,
                "All of your profile information will be deleted.",
              ),
              const SizedBox(height: 8),
              _deletePointer(
                theme,
                "All of your application information and history will be deleted.",
              ),
              const SizedBox(height: 8),
              _deletePointer(
                theme,
                "Invoices, confirmation letters, and related records will be deleted.",
              ),
              const SizedBox(height: 8),
              _deletePointer(
                theme,
                "All other stored data associated with your account will be deleted permanently.",
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.slg),

        /// ================= CTA =================
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: "Delete Account",
            variant: AppButtonVariant.delete,
            onPressed: () {
              showDeleteDialog(context);
            },
          ),
        ),
      ],
    ),
  );
}

Widget _deletePointer(ThemeData theme, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.error02,
            shape: BoxShape.circle,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.neutrals02,
            fontSize: 13.5,
            height: 1.45,
          ),
        ),
      ),
    ],
  );
}