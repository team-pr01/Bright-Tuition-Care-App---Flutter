import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/settings/prersentation/widgets/card_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordForm extends ConsumerStatefulWidget {

  const PasswordForm({super.key});

  @override
  ConsumerState<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends ConsumerState<PasswordForm> {
  final _formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState.loading;

    return cardWrapper(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Current Password
            AppInputField(
              label: "Current Password",
              type: AppInputType.password,
              controller: currentPasswordController,
              
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? "Current password is required"
                      : null,
            ),


            /// New Password
            AppInputField(
              label: "New Password",
              type: AppInputType.password,
              controller: newPasswordController,
              
              validator: (value) {
                final input = value?.trim() ?? "";
                if (input.isEmpty) return "New password is required";
                if (input.length < 6) return "Min 6 characters required";
                return null;
              },
            ),


            /// Confirm Password
            AppInputField(
              label: "Confirm Password",
              type: AppInputType.password,
              controller: confirmPasswordController,
              
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please confirm password";
                }
                if (value.trim() != newPasswordController.text.trim()) {
                  return "Passwords do not match";
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            /// BUTTON
            AppButton(
              label:  "Update",
              loading: isLoading,
              onPressed: isLoading
                  ? null
                  : () async {

                      if (!_formKey.currentState!.validate()) return;

                      final success = await ref
                          .read(authProvider.notifier)
                          .changePassword(
                            currentPassword:
                                currentPasswordController.text.trim(),
                            newPassword:
                                newPasswordController.text.trim(),
                          );

                      if (success) {
                        AppSnackbar.show(
                          context,
                          "Password changed successfully",
                          SnackType.success,
                        );

                        currentPasswordController.clear();
                        newPasswordController.clear();
                        confirmPasswordController.clear();
                      } else {
                        AppSnackbar.show(
                          context,
                          "Failed to change password",
                          SnackType.error,
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}