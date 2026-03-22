import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/layout/auth_layout.dart';
import 'package:btcclient/core/routing/app_router.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/segmented_switch/segmented_switch.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';

import 'package:btcclient/features/auth/data/requests/signup_request.dart';
import 'package:btcclient/features/auth/presentation/screens/login_screen.dart';
import 'package:btcclient/features/auth/presentation/screens/otp_screen.dart';
import 'package:btcclient/features/auth/presentation/widgets/auth_listener.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';

import 'package:btcclient/features/legal/presentation/terms_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/gestures.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final String role;
  const RegisterScreen({super.key, required this.role});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late int selected;
  String? selectedGender;
  @override
  void initState() {
    super.initState();

    /// convert role → index
    selected = widget.role == "tutor" ? 0 : 1;
  }

  bool rememberMe = false;

  List<String> subjects = [];
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    /// Check gender
    if (selectedGender == null) {
      AppSnackbar.show(context, "Please select gender", SnackType.warning);
      return;
    }

    /// Check password match
    if (passwordController.text != confirmPasswordController.text) {
      AppSnackbar.show(context, "Passwords do not match", SnackType.error);
      return;
    }

    /// Check terms accepted
    if (!rememberMe) {
      AppSnackbar.show(
        context,
        "You must accept Terms & Privacy Policy",
        SnackType.warning,
      );
      return;
    }

    final role = selected == 0 ? "tutor" : "guardian";

    final request = SignupRequest(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      gender: selectedGender!.toLowerCase(),
      role: role,
      city: "", // replace with your controller later
      area: "", // replace with your controller later
      password: passwordController.text.trim(),
    );

    await ref.read(authProvider.notifier).signup(request);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    ref.listen(authProvider, (previous, next) {
      /// Signup success
      if (previous?.loading == true &&
          next.loading == false &&
          next.error == null) {
        AppSnackbar.show(context, "OTP sent successfully", SnackType.success);

        /// Navigate to OTP screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(
              title: "Verify OTP",
              subtitle: "Enter OTP sent to",
              phoneNumber: phoneController.text.trim(),

              onVerify: (otp) async {
                final success = await ref
                    .read(authProvider.notifier)
                    .verifyOtp(email: emailController.text.trim(), otp: otp);

                return success;
              },

              onResend: () async {
                final success = await ref
                    .read(authProvider.notifier)
                    .resendOtp(email: emailController.text.trim());

                if (success) {
                  AppSnackbar.show(
                    context,
                    "OTP resent successfully",
                    SnackType.success,
                  );
                }
              },

              onSuccess: () {
                final role = ref.read(authProvider).role;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppRouter.getDashboardByRole(role),
                  ),
                  (route) => false,
                );
              },
            ),
          ),
        );
      }

      /// Error handling
      if (next.error != null && next.error != previous?.error) {
        AppSnackbar.show(context, next.error!, SnackType.error);
      }
    });
    return AuthListener(
      child: AuthLayout(
        title: "Create Account",
        subtitle: "Sign up as tutor or guardian/student",

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              /// SEGMENT SWITCH
              SegmentedSwitch(
                items: const ["Tutor", "Guardian/Student"],
                selectedIndex: selected,
                onChanged: (index) {
                  setState(() {
                    selected = index;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// NAME
              AppInputField(
                label: "Full Name",
                hint: "Enter your name",
                controller: nameController,
                required: true,
              ),

              /// EMAIL
              AppInputField(
                label: "Email",
                hint: "Enter your email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                required: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email is required";
                  }

                  final emailRegex = RegExp(
                    r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$',
                  );

                  if (!emailRegex.hasMatch(value.trim())) {
                    return "Enter valid email";
                  }

                  return null;
                },
              ),

              /// PHONE
              AppInputField(
                label: "Phone",
                hint: "Enter your phone",
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Phone number is required";
                  }

                  final bdPhoneRegex = RegExp(r'^01[3-9]\d{8}$');

                  if (!bdPhoneRegex.hasMatch(value.trim())) {
                    return "Enter valid Bangladeshi phone number";
                  }

                  return null;
                },
                keyboardType: TextInputType.phone,
                required: true,
              ),

              AppInputField(
                label: "Gender",
                type: AppInputType.dropdown,
                required: true,
                value: selectedGender,
                dropdownItems: const ["Male", "Female", "Other"],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),

              /// PASSWORD
              AppInputField(
                label: "Password",
                hint: "********",
                type: AppInputType.password,
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                required: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }

                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }

                  return null;
                },
              ),

              /// CONFIRM PASSWORD
              AppInputField(
                label: "Confirm Password",
                hint: "********",
                type: AppInputType.password,
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                required: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirm password required";
                  }

                  if (value != passwordController.text) {
                    return "Passwords do not match";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: Checkbox(
                      value: rememberMe,
                      onChanged: (val) {
                        setState(() {
                          rememberMe = val ?? false;
                        });
                      },
                      activeColor: AppColors.primary01,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      side: BorderSide(color: AppColors.neutrals03),
                    ),
                  ),

                  const SizedBox(width: 8),

                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.neutrals03,
                      ),

                      children: [
                        const TextSpan(text: "I agree to the "),

                        TextSpan(
                          text: "Terms of Use",
                          style: const TextStyle(
                            color: AppColors.primary01,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TermsScreen(),
                                ),
                              );
                            },
                        ),

                        const TextSpan(text: " and "),

                        TextSpan(
                          text: "Privacy Policy",
                          style: const TextStyle(
                            color: AppColors.primary01,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => const PrivacyScreen(),
                              //   ),
                              // );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              /// REGISTER BUTTON
              AppButton(
                label: "Create Account",
                variant: AppButtonVariant.gradient,
                loading: authState.loading,
                onPressed: authState.loading ? null : _register,
              ),
              const SizedBox(height: 24),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall!.copyWith(color: AppColors.neutrals03, ),

                  children: [
                    const TextSpan(text: "Already have an account?"),

                    TextSpan(
                      text: " Sign In",
                      style: const TextStyle(
                        color: AppColors.primary01,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
