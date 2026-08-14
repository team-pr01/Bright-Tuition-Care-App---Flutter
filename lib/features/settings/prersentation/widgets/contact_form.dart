import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/settings/prersentation/widgets/card_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactForm extends ConsumerStatefulWidget {
  final bool isProfileLocked;

  const ContactForm({super.key, required this.isProfileLocked});

  @override
  ConsumerState<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends ConsumerState<ContactForm> {
  final phnoController = TextEditingController();

  @override
  void dispose() {
    phnoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final authState = ref.watch(authProvider);
    final isLoading = authState.loading;
    return cardWrapper(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              widget.isProfileLocked
                  ? "Your profile is locked. Unlock it to update your contact details."
                  : "Manage your contact details.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.neutrals03,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            AppInputField(
              label: "Phone Number",
              controller: phnoController,
              enabled: !widget.isProfileLocked,
                hint:"eg: 01xxxxxxxxx",
              required: true,
            ),

            const SizedBox(height: AppSpacing.lg),

            AppButton(
              loading: isLoading,
              label: widget.isProfileLocked ? "Unlock Profile" : "Update",
              onPressed: () async {
                if (widget.isProfileLocked) {
                  AppSnackbar.show(
                    context,
                    "Your profile is locked. Please request unlock first.",
                    SnackType.warning,
                  );
                  return;
                }

                final phone = phnoController.text.trim();

                if (phone.isEmpty) {
                  AppSnackbar.show(
                    context,
                    "Phone number is required",
                    SnackType.error,
                  );
                  return;
                }

                final success = await ref
                    .read(authProvider.notifier)
                    .updateProfile({"phoneNumber": phone});

                if (success) {
                  phnoController.clear();
                  FocusScope.of(context).unfocus();
                  AppSnackbar.show(
                    context,
                    "Profile updated successfully",
                    SnackType.success,
                  );

                  print("✅ UPDATED PHONE: $phone");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
