import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/layout/auth_layout.dart';
import 'package:btcclient/core/routing/app_router.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/segmented_switch/segmented_switch.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:btcclient/features/auth/presentation/screens/register_screen.dart';
import 'package:btcclient/features/auth/presentation/widgets/auth_listener.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 0 = Tutor
  // 1 = Guardian/Student
  int? selected;

  bool rememberMe = false;

  @override
  void initState() {
    super.initState();

    // Set the selected tab according to the role
    final role = widget.role.toLowerCase().trim();

    if (role == "tutor") {
      selected = 0;
    } else if (role == "guardian" ||
        role == "student" ||
        role == "guardian/student") {
      selected = 1;
    } else {
      selected = null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // =========================================================
  // LOGIN
  // =========================================================

  void _login() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selected == null) {
      AppSnackbar.show(context, "Please select a role", SnackType.warning);
      return;
    }

    final role = selected == 0 ? "tutor" : "guardian";

    ref
        .read(authProvider.notifier)
        .login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          role: role,
        );
  }

  // =========================================================
  // FORGOT PASSWORD
  // =========================================================

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  // =========================================================
  // REGISTER
  // =========================================================

  void _registerAsGuardian() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen(role: "guardian")),
    );
  }

  void _registerAsTutor() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen(role: "tutor")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // =========================================================
    // AUTH LISTENER
    // =========================================================

    ref.listen(authProvider, (previous, next) {
      if (next.loggedIn == true) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => AppRouter.getDashboardByRole(next.role),
          ),
          (route) => false,
        );
      }

      if (next.error != null && next.error != previous?.error) {
        AppSnackbar.show(context, next.error!, SnackType.error);
      }
    });

    // =========================================================
    // CURRENT ROLE TEXT
    // =========================================================

    final roleText = selected == null
        ? ""
        : selected == 0
        ? "Tutor"
        : "Guardian";

    return AuthListener(
      child: AuthLayout(
        title: "Get Started Now",
        subtitle: "Create an account or sign in as tutor or guardian/student",
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // =================================================
              // ROLE SWITCH
              // =================================================

              // SegmentedSwitch(
              //   items: const [
              //     "Tutor",
              //     "Guardian/Student",
              //   ],
              //   selectedIndex: selected,
              //   onChanged: (index) {
              //     setState(() {
              //       selected = index;
              //     });
              //   },
              // ),
              const SizedBox(height: 20),

              // =================================================
              // EMAIL
              // =================================================
              AppInputField(
                label: "Email",
                hint: "Enter your email",
                controller: emailController,
                required: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email is required";
                  }

                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );

                  if (!emailRegex.hasMatch(value.trim())) {
                    return "Enter a valid email";
                  }

                  return null;
                },
              ),

              // =================================================
              // PASSWORD
              // =================================================
              AppInputField(
                label: "Password",
                hint: "Enter password",
                type: AppInputType.password,
                controller: passwordController,
                required: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 8),

              // =================================================
              // FORGOT PASSWORD
              // =================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _forgotPassword,
                    child: Text(
                      "Forgot Password?",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: AppColors.primary01,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // =================================================
              // SIGN IN
              // =================================================
              AppButton(
                label: "Sign In",
                variant: AppButtonVariant.gradient,
                loading: authState.loading,
                onPressed: authState.loading ? null : _login,
              ),

              const SizedBox(height: 24),

              // =================================================
              // CREATE ACCOUNT TEXT
              // =================================================
              Text(
                "Don’t have an account?",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall!.copyWith(color: AppColors.neutrals03),
              ),

              const SizedBox(height: 16),

              // =================================================
              // GUARDIAN SIGN UP
              // =================================================
              AppButton(
                label: "Join as Guardian/Student",
                variant: AppButtonVariant.outlineGray,
                fontSize: 16,
                textColor: AppColors.primary01,
                onPressed: _registerAsGuardian,
              ),

              const SizedBox(height: 12),

              // =================================================
              // TUTOR SIGN UP
              // =================================================
              AppButton(
                label: "Join as Tutor",
                variant: AppButtonVariant.outlineGray,
                fontSize: 16,
                textColor: AppColors.primary01,
                onPressed: _registerAsTutor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
