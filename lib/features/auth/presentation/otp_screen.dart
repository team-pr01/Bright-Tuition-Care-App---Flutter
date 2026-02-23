import 'package:flutter/material.dart';
import '../../../core/layout/auth_layout.dart';
import '../../../core/widgets/button/app_button.dart';

class OtpScreen extends StatefulWidget {

  final String title;
  final String subtitle;
  final String destination; // phone or email

  /// Called when OTP entered
  final Future<bool> Function(String otp) onVerify;

  /// Called when resend pressed
  final Future<void> Function()? onResend;

  /// Called on success
  final VoidCallback onSuccess;

  const OtpScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.destination,
    required this.onVerify,
    required this.onSuccess,
    this.onResend,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final controller = TextEditingController();

  bool loading = false;
  String? error;

  Future<void> verify() async {

    if (controller.text.length != 6) {
      setState(() => error = "Enter valid 6-digit OTP");
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    final success = await widget.onVerify(controller.text);

    setState(() => loading = false);

    if (success) {
      widget.onSuccess();
    }
    else {
      setState(() => error = "Invalid OTP");
    }
  }

  @override
  Widget build(BuildContext context) {

    return AuthLayout(

      title: widget.title,

      subtitle:
          "${widget.subtitle}\n${widget.destination}",

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          /// OTP FIELD
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 6,
            style: const TextStyle(
              fontSize: 20,
              letterSpacing: 8,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: "000000",
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          /// VERIFY BUTTON
          AppButton(
            label: "Verify OTP",
            loading: loading,
            variant: AppButtonVariant.gradient,
            onPressed: verify,
          ),
/// ERROR
          if (error != null) ...[
            const SizedBox(height: 10),
            Text(
              error!,
              style: const TextStyle(color: Colors.red),
            )
          ],
          const SizedBox(height: 12),

          /// RESEND
          TextButton(
            onPressed: widget.onResend,
            child: const Text("Resend OTP"),
          ),

          
        ],
      ),
    );
  }
}
