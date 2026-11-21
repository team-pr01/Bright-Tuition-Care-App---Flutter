import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/settings/prersentation/widgets/password_form.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutrals01,
      appBar: const CommonAppBar(title: "Change Password"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xs),

              Text("Update Your Password", style: AppTextStyles.headlineSmall),

              const SizedBox(height: AppSpacing.xs),
              Text(
                "Enter your current password and choose a strong new password of at least 8 characters to keep your account secure.",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutrals03,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              /// ================= FORM =================
              const PasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}
