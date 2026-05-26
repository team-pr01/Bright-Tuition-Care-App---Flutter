import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/settings/prersentation/provider/verification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddressVerificationForm extends ConsumerStatefulWidget {
  final String? addressCodeFromApi;

  const AddressVerificationForm({super.key, required this.addressCodeFromApi});

  @override
  ConsumerState<AddressVerificationForm> createState() =>
      _AddressVerificationFormState();
}

class _AddressVerificationFormState
    extends ConsumerState<AddressVerificationForm> {
  final controller = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verificationState = ref.watch(verificationProvider);

    bool localSubmitted = false;

    final isAlreadySubmitted =
        widget.addressCodeFromApi != null || localSubmitted;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),

      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),

        borderRadius: BorderRadius.circular(AppRadius.large),

        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              /// ================= ICON =================
              Container(
                width: 52,
                height: 52,

                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.mail_outline,
                  color: Colors.blue,
                  size: 28,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              /// ================= CONTENT =================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Enter Verification Code",

                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Please enter the "Verification Code" which you have received via notification.If you have not received any code, please contact our support team.',

            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.neutrals03,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          /// ================= FORM =================
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
                  return "Please enter verification code";
                }

                return null;
              },
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          /// ================= BUTTON =================
          AppButton(
            label: verificationState.loading
                ? "Verifying..."
                : isAlreadySubmitted
                ? "Submitted"
                : "Submit Code",

            variant: AppButtonVariant.gradient,

            icon: Icons.check,

            loading: verificationState.loading,

            onPressed: verificationState.loading || isAlreadySubmitted
                ? null
                : () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    final success = await ref
                        .read(verificationProvider.notifier)
                        .submitAddressCode(controller.text.trim());

                    if (!mounted) {
                      return;
                    }

                    if (success) {
                      AppSnackbar.show(
                        context,

                        "Address verification code submitted successfully",

                        SnackType.success,
                      );
                    } else {
                      final latestState = ref.read(verificationProvider);

                      AppSnackbar.show(
                        context,

                        latestState.error ??
                            "Failed to submit verification code",

                        SnackType.error,
                      );
                    }
                  },
          ),

          const SizedBox(height: AppSpacing.md),

          /// ================= INFO BOX =================
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),

            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),

              borderRadius: BorderRadius.circular(AppRadius.small),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Icon(Icons.info_outline, size: 18, color: Colors.blue),

                const SizedBox(width: AppSpacing.sm),

                Expanded(
                  child: Text(
                    isAlreadySubmitted
                        ? "We have received your address verification code. It's under review."
                        : "The verification code will be sent to you via notification.",

                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
