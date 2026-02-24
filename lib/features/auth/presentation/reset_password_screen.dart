import 'package:btcclient/core/storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/layout/auth_layout.dart';
import '../../../core/widgets/button/app_button.dart';
import '../../../core/widgets/input/app_input_field.dart';
import '../../auth/provider/auth_notifier.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {

  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();

}

class _ResetPasswordScreenState
    extends ConsumerState<ResetPasswordScreen> {

  final passwordController =
      TextEditingController();

  final confirmController =
      TextEditingController();

  bool loading = false;
  String? error;

  @override
  void dispose() {

    passwordController.dispose();
    confirmController.dispose();

    super.dispose();

  }

  Future<void> _submit() async {

    final password =
        passwordController.text.trim();

    final confirm =
        confirmController.text.trim();

    /// FIX: get identifier from storage
    final phone =
        await LocalStorage.getAuthIdentifier();

    if (phone == null) {

      setState(() {
        error = "Session expired";
      });

      return;

    }

    /// validation
    if (password.isEmpty ||
        confirm.isEmpty) {

      setState(() {
        error = "Please fill all fields";
      });

      return;

    }

    if (password.length < 6) {

      setState(() {
        error =
            "Password must be at least 6 characters";
      });

      return;

    }

    if (password != confirm) {

      setState(() {
        error =
            "Passwords do not match";
      });

      return;

    }

    setState(() {
      loading = true;
      error = null;
    });

    final success =
        await ref
            .read(authProvider.notifier)
            .resetPassword(
              phoneNumber: phone,
              newPassword: password,
            );

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    if (success) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Password reset successful"),
          backgroundColor:
              Colors.green,
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/login",
        (route) => false,
      );

    } else {

      setState(() {
        error = "Reset failed";
      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return AuthLayout(

      title: "Reset Password",

      subtitle:
          "Create a new secure password",

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.stretch,

        children: [

          AppInputField(
            label: "New Password",
            hint:
                "Enter new password",
            controller:
                passwordController,
            type:
                AppInputType.password,
            required: true,
          ),

          AppInputField(
            label:
                "Confirm Password",
            hint:
                "Re-enter password",
            controller:
                confirmController,
            type:
                AppInputType.password,
            required: true,
          ),

          const SizedBox(
              height: 20),

          AppButton(
            label:
                "Reset Password",
            variant:
                AppButtonVariant.gradient,
            loading: loading,
            onPressed: _submit,
          ),

          if (error != null) ...[

            const SizedBox(
                height: 12),

            Text(
              error!,
              style:
                  const TextStyle(
                color:
                    Colors.red,
              ),
            ),

          ]

        ],

      ),

    );

  }

}