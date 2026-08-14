import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showUnlockModal(BuildContext context) {
  final TextEditingController reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Consumer(
        builder: (context, ref, _) {
          final isLoading = ref.watch(authProvider).loading;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ReusableBottomSheet(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: AppSpacing.sm),

                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.primary01.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_open_rounded,
                          size: 40,
                          color: AppColors.primary01,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      Text(
                        "Unlock Profile",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      Text(
                        "Are you sure you want to request to unlock your profile?",
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      AppInputField(
                        label: "Reason for Unlocking Profile",
                        controller: reasonController,
                        type: AppInputType.multiline,
                        maxLines: 4,
                        hint:"I want update .... ",
                        required: true,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              label: "Cancel",
                              variant: AppButtonVariant.outlineGray,
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppButton(
                              label: "Submit",
                              variant: AppButtonVariant.gradient,
                              loading: isLoading,
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (!_formKey.currentState!.validate())
                                        return;

                                      final reason = reasonController.text
                                          .trim();

                                      final success = await ref
                                          .read(authProvider.notifier)
                                          .requestUnlockProfile(reason);

                                      if (success) {
                                        Navigator.pop(context);

                                        AppSnackbar.show(
                                          context,
                                          "Unlock request sent",
                                          SnackType.success,
                                        );
                                      } else {
                                        final error =
                                            ref.read(authProvider).error ??
                                            "Something went wrong";

                                        AppSnackbar.show(
                                          context,
                                          error,
                                          SnackType.error,
                                        );

                                        print("❌ ERROR: $error");
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
