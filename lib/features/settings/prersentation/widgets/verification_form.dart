import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/settings/prersentation/widgets/build_verification_step.dart';
import 'package:btcclient/features/settings/prersentation/widgets/card_wrapper.dart';
import 'package:btcclient/features/settings/prersentation/widgets/show_verification_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget verificationForm(
  BuildContext context,
  ThemeData theme,
  WidgetRef ref,
  bool isVerified,
  bool hasRequested,
  String? currentStepFromApi,
  String? addressCode,
) {
  final currentStep = currentStepFromApi ?? "idle";

  /// 🔥 CASE 1 → NO REQUEST YET
  if (currentStep == "idle") {
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
              showVerificationModal(context, ref);
            },
          ),
        ],
      ),
    );
  }

  /// 🔥 CASE 2 → ALL OTHER STATES (pending → verified)
  return cardWrapper(
    child: buildVerificationStep(
      theme: theme,
      currentStep: currentStep,
      addressCode: addressCode,
    ),
  );
}