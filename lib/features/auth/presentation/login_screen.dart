import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/layout/auth_layout.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/segmented_switch/segmented_switch.dart';
import 'package:btcclient/features/auth/presentation/forgot_password_screen.dart';
import 'package:btcclient/features/auth/presentation/register_screen.dart';
import 'package:btcclient/features/auth/provider/auth_provider.dart';
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

  int selected = 0;
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    final role = selected == 0 ? "tutor" : "guardian";

    // ref.read(authProvider.notifier).login(
    //   "dummy_token",
    //   role,
    // );
  }

  void _forgotPassword() {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ForgotPasswordScreen(

        onSendOtp: (value) async {

          /// TODO: call your API here

          /// example:
          /// final result = await authApi.sendForgotPasswordOtp(value);
          /// return result.success;

          await Future.delayed(const Duration(seconds: 1));

          return true; // temporary success

        },
      ),
    ),
  );

}


  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return AuthLayout(
      title: "Get Started Now",

      subtitle: "Create an account or sign in as tutor or guardian/student",

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

            /// EMAIL
            AppInputField(
              label: "Email",

              hint: "Enter your email",

              controller: emailController,

              required: true,
            ),

            /// PASSWORD
            AppInputField(
              label: "Password",

              hint: "*******",

              type: AppInputType.password,

              controller: passwordController,

              required: true,
            ),

            const SizedBox(height: 8),

            /// REMEMBER + FORGOT ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 12,

                      width: 12,
                      child: Checkbox(
                        value: rememberMe,

                        onChanged: (val) {
                          setState(() {
                            rememberMe = val ?? false;
                          });
                        },
                        checkColor: AppColors.neutrals01,
                        activeColor: AppColors.primary01,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),

                        side: BorderSide(color: AppColors.neutrals02),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      "Remember me",

                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.neutrals03,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: _forgotPassword,

                  child: Text(
                    "Forgot Password?",

                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary01,

                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// LOGIN BUTTON
            AppButton(
              label: "Sign In",

              variant: AppButtonVariant.gradient,

              loading: authState.loading,

              onPressed: _login,
            ),
            if (authState.error != null) ...[
              const SizedBox(height: 12),

              Text(
                authState.error!,

                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
            const SizedBox(height: 18),
            Text(
              "Don’t have an account?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: AppColors.neutrals03,
                fontWeight: FontWeight.w300,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            AppButton(
              label: "Join as Guardian/Student",
              variant: AppButtonVariant.outlineGray,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              textColor: Colors.blue,
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
              fontWeight: FontWeight.w400,
              textColor: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(role: "tutor"),
                  ),
                );
              },
            ),

            /// ERROR TEXT
          ],
        ),
      ),
    );
  }
}
