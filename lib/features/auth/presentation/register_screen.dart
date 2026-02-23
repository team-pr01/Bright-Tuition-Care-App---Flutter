import 'package:btcclient/core/layout/auth_layout.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/segmented_switch/segmented_switch.dart';
import 'package:btcclient/features/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select gender")));

      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));

      return;
    }

    /// Call register API
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return AuthLayout(
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
              required: true,
            ),

            /// PHONE
            AppInputField(
              label: "Phone",
              hint: "Enter your phone",
              controller: phoneController,
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
              required: true,
            ),

            /// CONFIRM PASSWORD
            AppInputField(
              label: "Confirm Password",
              hint: "********",
              type: AppInputType.password,
              controller: confirmPasswordController,
              required: true,
            ),

            const SizedBox(height: 24),

            /// REGISTER BUTTON
            AppButton(
              label: "Create Account",
              variant: AppButtonVariant.gradient,
              loading: authState.loading,
              onPressed: _register,
            ),

            /// ERROR TEXT
            if (authState.error != null) ...[
              const SizedBox(height: 12),
              Text(authState.error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
