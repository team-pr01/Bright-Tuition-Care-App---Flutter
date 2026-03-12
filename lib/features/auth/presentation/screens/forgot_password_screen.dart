import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/layout/auth_layout.dart';
import '../../../../core/widgets/input/app_input_field.dart';
import '../../../../core/widgets/button/app_button.dart';

import '../provider/auth_notifier.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  bool loading = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> sendOtp() async {
    if (loading) return;
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final phone = controller.text.trim();

    setState(() {
      loading = true;
    });

    final success = await ref
        .read(authProvider.notifier)
        .forgetPassword(phoneNumber: phone);

    setState(() {
      loading = false;
    });

    if (!success) {
      AppSnackbar.show(context, "Failed to send OTP", SnackType.error);
      return;
    }
    AppSnackbar.show(context, "OTP sent successfully", SnackType.success);

    /// Navigate ONLY if success
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          title: "Verify OTP",
          subtitle: "OTP sent to",
          phoneNumber: phone,

          onVerify: (otp) async {
            return await ref
                .read(authProvider.notifier)
                .verifyResetPasswordOtp(phoneNumber: phone, otp: otp);
          },

          onResend: () async {
            final success = await ref
                .read(authProvider.notifier)
                .resendForgotPasswordOtp(phoneNumber: phone);

            if (!success) {
              AppSnackbar.show(
                context,
                "Failed to resend OTP",
                SnackType.error,
              );
            }
          },

          onSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: "Forgot Password",
      subtitle: "Enter your phone to receive OTP",

      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppInputField(
              label: "Phone",
              hint: "Enter phone",
              controller: controller,
              required: true,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Phone number is required";
                }

                final regex = RegExp(r'^[0-9]{10}$');

                if (!regex.hasMatch(value.trim())) {
                  return "Enter valid 10 digit phone number";
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            AppButton(
              label: "Send OTP",
              loading: loading,
              variant: AppButtonVariant.gradient,
              onPressed: loading ? null : sendOtp,
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back to Login"),
            ),
          ],
        ),
      ),
    );
  }
}
