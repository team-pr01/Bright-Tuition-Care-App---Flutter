import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/layout/auth_layout.dart';
import 'package:btcclient/core/routing/app_router.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/segmented_switch/segmented_switch.dart';
import 'package:btcclient/features/auth/presentation/forgot_password_screen.dart';
import 'package:btcclient/features/auth/presentation/register_screen.dart';
import 'package:btcclient/features/auth/presentation/widgets/auth_listener.dart';
import 'package:btcclient/features/auth/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  int? selected;
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ================= LOGIN =================

  void _login() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (selected == null) {
      _showError("Please select role");
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

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

 void _forgotPassword() {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ForgotPasswordScreen(),
    ),
  );

}

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    /// Listen for login success / error
    ref.listen(authProvider, (previous, next) {

      /// show success only when login changes from false → true
      if (next.loggedIn == true) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => AppRouter.getDashboardByRole(next.role),
          ),
          (route) => false,
        );
      }

      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
    });

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
              // ================= ROLE SWITCH =================
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

              // ================= EMAIL =================
              AppInputField(
                label: "Email",

                hint: "Enter your email",

                controller: emailController,

                required: true,

                suffixIcon: const Icon(Icons.email_outlined),
              ),

              // ================= PASSWORD =================
              AppInputField(
                label: "Password",

                hint: "Enter password",

                type: AppInputType.password,

                controller: passwordController,

                required: true,
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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

                      Text(
                        "Remember me",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.neutrals03,
                        ),
                      ),
                    ],
                  ),

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

              AppButton(
                label: selected == null ? "Sign In" : "Sign In as $roleText",

                variant: AppButtonVariant.gradient,

                loading: authState.loading,

                onPressed: authState.loading ? null : _login,
              ),

              const SizedBox(height: 24),

              Text(
                "Don’t have an account?",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall!.copyWith(color: AppColors.neutrals03),
              ),

              const SizedBox(height: 16),

              AppButton(
                label: "Join as Guardian/Student",

                variant: AppButtonVariant.outlineGray,

                fontSize: 16,

                textColor: AppColors.primary01,

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(role: "guardian"),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              AppButton(
                label: "Join as Tutor",

                variant: AppButtonVariant.outlineGray,

                fontSize: 16,

                textColor: AppColors.primary01,

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(role: "tutor"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
