import 'package:flutter/material.dart';
import '../../../core/layout/auth_layout.dart';
import '../../../core/widgets/button/app_button.dart';
import '../../../core/widgets/input/app_input_field.dart';

class ResetPasswordScreen extends StatefulWidget {

  /// identifier can be email OR phone OR userId
  final String identifier;

  /// reusable callback for API
  final Future<bool> Function({
    required String identifier,
    required String password,
  }) onReset;

  const ResetPasswordScreen({
    super.key,
    required this.identifier,
    required this.onReset,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool loading = false;
  String? error;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {

    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    /// validation
    if (password.isEmpty || confirm.isEmpty) {
      setState(() => error = "Please fill all fields");
      return;
    }

    if (password.length < 6) {
      setState(() => error = "Password must be at least 6 characters");
      return;
    }

    if (password != confirm) {
      setState(() => error = "Passwords do not match");
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    final success = await widget.onReset(
      identifier: widget.identifier,
      password: password,
    );

    setState(() => loading = false);

    if (!success) {
      setState(() => error = "Failed to reset password");
      return;
    }

    /// success
    if (mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset successful"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return AuthLayout(

      title: "Reset Password",

      subtitle: "Create a new secure password",

      child: Form(

        key: _formKey,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// NEW PASSWORD
            AppInputField(
              label: "New Password",
              hint: "Enter new password",
              controller: passwordController,
              type: AppInputType.password,
              required: true,
            ),

            /// CONFIRM PASSWORD
            AppInputField(
              label: "Confirm Password",
              hint: "Re-enter password",
              controller: confirmController,
              type: AppInputType.password,
              required: true,
            ),

            const SizedBox(height: 20),

            /// RESET BUTTON
            AppButton(
              label: "Reset Password",
              variant: AppButtonVariant.gradient,
              loading: loading,
              onPressed: _submit,
            ),

            /// ERROR TEXT
            if (error != null) ...[
              const SizedBox(height: 12),
              Text(
                error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],

          ],
        ),
      ),
    );
  }
}
