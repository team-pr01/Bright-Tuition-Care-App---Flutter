import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/settings/prersentation/widgets/build_verification_step.dart';
import 'package:btcclient/features/settings/prersentation/widgets/card_wrapper.dart';
import 'package:btcclient/features/settings/prersentation/widgets/show_verification_modal.dart';
import 'package:flutter/material.dart';

Widget verificationForm(
  BuildContext context,
  ThemeData theme,
  bool isVerified,
  bool hasRequested,
  String? currentStepFromApi,
  String? addressCode,
) {
  /// 🔥 fallback (first step)
  final currentStep =
      currentStepFromApi ?? "pending";

  if (!hasRequested && !isVerified) {
    return cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verify Your Profile",
              style: theme.textTheme.headlineSmall),

          const SizedBox(height: AppSpacing.md),

          Text(
            "Your profile is not verified yet. Request verification to continue.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.neutrals03,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          AppButton(
            label: "Request for Verification",
            variant: AppButtonVariant.gradient,
            onPressed: () {
              showVerificationModal(context);
            },
          ),
        ],
      ),
    );
  }

  /// 🔥 SAME AS REACT
  return cardWrapper(
    child: buildVerificationStep(
      theme: theme,
      currentStep: currentStep,
      addressCode: addressCode,
    ),
  );
}