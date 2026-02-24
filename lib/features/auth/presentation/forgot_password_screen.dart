import 'package:flutter/material.dart';
import '../../../core/layout/auth_layout.dart';
import '../../../core/widgets/input/app_input_field.dart';
import '../../../core/widgets/button/app_button.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {

  final Future<bool> Function(String value) onSendOtp;

  const ForgotPasswordScreen({
    super.key,
    required this.onSendOtp,
  });

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final controller = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool loading = false;

  String? error;

  Future<void> sendOtp() async {

    if (controller.text.trim().isEmpty) {

      setState(() {
        error = "Enter phone";
      });

      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    final success =
        await widget.onSendOtp(controller.text.trim());

    setState(() => loading = false);

    if (!success) {

      setState(() {
        error = "Failed to send OTP";
      });

      return;
    }

    // / Navigate to OTP screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(

          title: "Verify OTP",

          subtitle: "OTP sent to",

          phoneNumber: controller.text.trim(),

          onVerify: (otp) async {

            /// call verify forgot password OTP API
            return true;

          },

          onSuccess: () {

            Navigator.pushReplacementNamed(
              context,
              "/reset-password",
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

      subtitle:
          "Enter your phone to receive OTP",

      child: Form(

        key: formKey,

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [

            AppInputField(
              label: "Phone",
              hint: "Enter  phone",
              controller: controller,
              required: true,
            ),

            const SizedBox(height: 20),

            AppButton(
              label: "Send OTP",
              variant: AppButtonVariant.gradient,
              loading: loading,
              onPressed: sendOtp,
            ),

            if (error != null) ...[
              const SizedBox(height: 12),

              Text(
                error!,
                style: const TextStyle(
                  color: Colors.red,
                ),
              )
            ],

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Back to Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
