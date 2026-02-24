import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/layout/auth_layout.dart';
import '../../../core/widgets/input/app_input_field.dart';
import '../../../core/widgets/button/app_button.dart';

import '../../auth/provider/auth_notifier.dart';
import '../../auth/presentation/otp_screen.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final controller = TextEditingController();

  bool loading = false;
  String? error;

  Future<void> sendOtp() async {
    final phone = controller.text.trim();

    if (phone.isEmpty) {
      setState(() {
        error = "Enter phone number";
      });

      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    /// Navigate to OTP screen
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

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("OTP resent successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },

          onSuccess: () {
            Navigator.pushReplacementNamed(context, "/reset-password");
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

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          AppInputField(
            label: "Phone",
            hint: "Enter phone",
            controller: controller,
            required: true,
          ),

          const SizedBox(height: 20),

          AppButton(
            label: "Send OTP",
            loading: loading,
            variant: AppButtonVariant.gradient,
            onPressed: sendOtp,
          ),

          if (error != null) ...[
            const SizedBox(height: 12),

            Text(error!, style: const TextStyle(color: Colors.red)),
          ],

          const SizedBox(height: 20),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back to Login"),
          ),
        ],
      ),
    );
  }
}
