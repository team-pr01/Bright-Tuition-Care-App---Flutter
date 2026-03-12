import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/layout/auth_layout.dart';
import '../../../../core/widgets/button/app_button.dart';
import '../../../../core/widgets/input/app_input_field.dart';
import '../provider/auth_notifier.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final passwordController = TextEditingController();

  final confirmController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    final password = passwordController.text.trim();

    final confirm = confirmController.text.trim();

    /// FIX: get identifier from storage
    final phone = await LocalStorage.getAuthIdentifier();

    if (phone == null) {
      AppSnackbar.show(context, "Session expired", SnackType.error);

      return;
    }

    /// validation
    AppSnackbar.show(context, "Please fill all fields", SnackType.warning);

    if (password.length < 6) {
      AppSnackbar.show(
        context,
        "Password must be at least 6 characters",
        SnackType.warning,
      );

      return;
    }

    if (password != confirm) {
      AppSnackbar.show(context, "Passwords do not match", SnackType.warning);

      return;
    }

    setState(() {
      loading = true;
    });

    final success = await ref
        .read(authProvider.notifier)
        .resetPassword(phoneNumber: phone, newPassword: password);

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    if (success) {
      AppSnackbar.show(context, "Password reset successful", SnackType.success);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else {
      AppSnackbar.show(context, "Reset failed", SnackType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: "Reset Password",

      subtitle: "Create a new secure password",

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          AppInputField(
            label: "New Password",
            hint: "Enter new password",
            keyboardType: TextInputType.visiblePassword,
            controller: passwordController,
            type: AppInputType.password,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }

              if (value.length < 6) {
                return "Password must be at least 6 characters";
              }

              return null;
            },
            required: true,
          ),

          AppInputField(
            label: "Confirm Password",
            hint: "Re-enter password",
            keyboardType: TextInputType.visiblePassword,
            controller: confirmController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Confirm password required";
              }

              if (value != passwordController.text) {
                return "Passwords do not match";
              }

              return null;
            },
            type: AppInputType.password,
            required: true,
          ),

          const SizedBox(height: 20),

          AppButton(
            label: "Reset Password",
            variant: AppButtonVariant.gradient,
            loading: loading,
            onPressed: loading ? null : _submit,
          ),
        ],
      ),
    );
  }
}
