import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/auth/presentation/screens/welcome_screen.dart';
import 'package:btcclient/features/invoices/presentation/provider/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showLogoutDialog(BuildContext context) {
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (bottomSheetContext) {
      return Consumer(
        builder: (context, ref, child) {
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
                    Icons.logout_rounded,
                    size: 40,
                    color: AppColors.error,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                /// TITLE
                Text(
                  "Logout",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                /// DESCRIPTION
                Text(
                  "Are you sure you want to logout from your account?",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutrals03,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        variant: AppButtonVariant.outlineGray,
                        label: "Cancel",
                        onPressed: () {
                          Navigator.of(bottomSheetContext).pop();
                        },
                      ),
                    ),

                    const SizedBox(width: AppSpacing.sm),

                    Expanded(
                      child: AppButton(
                        label: "Logout",
                        variant: AppButtonVariant.delete,
                        onPressed: () async {
                          try {
                            await ref
                                .read(authProvider.notifier)
                                .logout();

                            ref
                                .read(invoiceProvider.notifier)
                                .clear();

                            if (!context.mounted) return;

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const WelcomeScreen(),
                              ),
                              (route) => false,
                            );
                          } catch (e) {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Failed to logout. Please try again.",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          );
        },
      );
    },
  );
}