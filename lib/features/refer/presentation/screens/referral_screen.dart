import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/refer/presentation/screens/my_leads_screen.dart';
import 'package:btcclient/features/refer/presentation/screens/refer_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';

import 'package:btcclient/features/refer/data/referral_data.dart';
import 'package:btcclient/features/refer/presentation/widgets/referral_card.dart';

import '../../../../core/config/theme.dart';

class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  Future<void> copyLink(BuildContext context, String link) async {
    await Clipboard.setData(ClipboardData(text: link));
    AppSnackbar.show(context, "Link copied to clipboard", SnackType.success);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    final String link =
        "https://brighttuitioncare.com/tuition-request/referral/${user?.roleBasedId}";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: const CommonAppBar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// TITLE
            Text(
              "Earn Money by Referring Students",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(color: AppColors.neutrals02),
            ),

            const SizedBox(height: 12),

            /// SUBTITLE
            Text(
              "Share your referral link with students or guardians and earn money every time they enroll with a tutor through our platform.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.neutrals03,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            /// CARDS
            ...referralSteps.map(
              (step) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ReferralCard(step: step),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTON ROW
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: "My Leads",
                    variant: AppButtonVariant.gradient,
                     onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MyLeadsScreen(),
                              ),
                            );
                          },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: AppButton(
                    variant: AppButtonVariant.gradient,
                    label: "Add New Lead",
                    onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddLeadScreen(),
                              ),
                            );
                          },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// MY LEADS
            SizedBox(
              child: AppButton(
                label: "Copy Referral Link",
                variant: AppButtonVariant.outlineGray,
                icon: Icons.copy,
                onPressed: () {
                  copyLink(context,link);
                },
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
