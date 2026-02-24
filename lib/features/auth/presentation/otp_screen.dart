import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/layout/auth_layout.dart';
import '../../../core/widgets/button/app_button.dart';
import '../../../core/config/theme.dart';

class OtpScreen extends StatefulWidget {

  final String title;
  final String subtitle;
  final String phoneNumber;

  final Future<bool> Function(String otp) onVerify;
  final Future<void> Function()? onResend;
  final VoidCallback onSuccess;

  const OtpScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.phoneNumber,
    required this.onVerify,
    required this.onSuccess,
    this.onResend,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(4, (_) => FocusNode());

  bool loading = false;
  String? error;

  Timer? timer;
  int secondsRemaining = 60;
  bool canResend = false;

  String get otp =>
      controllers.map((e) => e.text).join();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  void startTimer() {

    secondsRemaining = 60;
    canResend = false;

    timer?.cancel();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {

        if (secondsRemaining == 0) {

          setState(() {
            canResend = true;
          });

          timer.cancel();

        } else {

          setState(() {
            secondsRemaining--;
          });

        }

      },
    );

  }

  Future<void> resendOtp() async {

    if (!canResend) return;

    await widget.onResend?.call();

    startTimer();

  }

  Future<void> verify() async {

    if (otp.length != 4) {
      setState(() => error = "Enter valid 4-digit OTP");
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    final success = await widget.onVerify(otp);

    setState(() => loading = false);

    if (success) {
      widget.onSuccess();
    } else {
      setState(() => error = "Invalid OTP");
    }

  }

  void onChanged(String value, int index) {

    if (value.length == 1 && index < 3) {
      focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

  }

  Widget otpBox(int index) {

    return SizedBox(
      width: 50,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
  counterText: "", // ← ADD THIS LINE

  hintStyle: const TextStyle(
    fontSize: 14,
    color: AppColors.neutrals03,
  ),
  contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  filled: true,
  fillColor: AppColors.neutrals01,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.primary01.withOpacity(0.3),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(
      color: AppColors.primary01,
      width: 1.5,
    ),
  ),
), onChanged: (value) => onChanged(value, index),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return AuthLayout(

      title: widget.title,

      subtitle:
          "${widget.subtitle}\n${widget.phoneNumber}",

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
              spacing: 10,
            children: List.generate(
              4,
              (index) => otpBox(index),
            ),
          ),

          const SizedBox(height: 24),

          AppButton(
            label: "Verify OTP",
            loading: loading,
            variant: AppButtonVariant.gradient,
            onPressed: verify,
          ),

          if (error != null) ...[
            const SizedBox(height: 10),
            Text(
              error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ],

          const SizedBox(height: 20),

          Center(
            child: canResend
                ? TextButton(
                    onPressed: resendOtp,
                    child: const Text("Resend OTP"),
                  )
                : Text(
                    "Resend in $secondsRemaining sec",
                    style: TextStyle(
                      color: AppColors.neutrals03,
                    ),
                  ),
          ),

        ],
      ),
    );

  }

}