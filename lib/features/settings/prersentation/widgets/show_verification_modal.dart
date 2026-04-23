import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import 'package:flutter/material.dart';

void showVerificationModal(BuildContext context) {
  bool isLoading = false;
  bool isSuccess = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final theme = Theme.of(context);

      return StatefulBuilder(
        builder: (context, setState) {
          return ReusableBottomSheet(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// CLOSE
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                /// ICON
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSuccess
                        ? Colors.green.withOpacity(0.1)
                        : AppColors.primary01.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess
                        ? Icons.check_circle
                        : Icons.verified_user,
                    size: 40,
                    color: isSuccess
                        ? Colors.green
                        : AppColors.primary01,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                /// TITLE
                Text(
                  isSuccess ? "Request Received" : "Verification",
                  style: theme.textTheme.headlineSmall,
                ),

                const SizedBox(height: AppSpacing.sm),

                /// TEXT
                Text(
                  isSuccess
                      ? "We have received your verification request. We will review it and notify you."
                      : "Are you sure you want to send verification request?",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutrals03,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                /// BUTTONS
                if (!isSuccess)
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: "No",
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppButton(
                          label: isLoading ? "Sending..." : "Yes",
                          variant: AppButtonVariant.gradient,
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setState(() => isLoading = true);

                                  try {
                                    /// 🔥 API CALL HERE
                                    await Future.delayed(
                                        const Duration(seconds: 1));

                                    setState(() {
                                      isLoading = false;
                                      isSuccess = true;
                                    });
                                  } catch (e) {
                                    setState(() => isLoading = false);
                                  }
                                },
                        ),
                      ),
                    ],
                  )
                else
                  AppButton(
                    label: "Close",
                    variant: AppButtonVariant.gradient,
                    onPressed: () {
                      Navigator.pop(context);

                      /// 🔥 Optional: refresh screen
                    },
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}