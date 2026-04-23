import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:flutter/material.dart';

Widget addressVerificationForm({
  required ThemeData theme,
  required String? addressCodeFromApi,
  required Function(String code) onSubmit,
}) {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isAlreadySubmitted = addressCodeFromApi != null;

  return Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.primary01.withOpacity(0.05),
      borderRadius: BorderRadius.circular(AppRadius.large),
      border: Border.all(color: AppColors.primary01.withOpacity(0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.mail, color: AppColors.primary01),
            const SizedBox(width: AppSpacing.sm),
            Text("Enter Verification Code",
                style: theme.textTheme.titleMedium),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        Text(
          "Enter the code you received via notification.",
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.neutrals03,
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        Form(
          key: formKey,
          child: AppInputField(
            label: "Verification Code",
            hint: "Enter 4-digit code",
            controller: controller,
            enabled: !isAlreadySubmitted,
            required: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Code required";
              }
              return null;
            },
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        AppButton(
          label: isAlreadySubmitted ? "Submitted" : "Submit Code",
          variant: AppButtonVariant.gradient,
          onPressed: isAlreadySubmitted
              ? null
              : () {
                  if (!formKey.currentState!.validate()) return;
                  onSubmit(controller.text.trim());
                },
        ),

        const SizedBox(height: AppSpacing.md),

        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.primary01.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          child: Text(
            isAlreadySubmitted
                ? "We have received your code. It’s under review."
                : "The code will be sent via notification.",
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    ),
  );
}