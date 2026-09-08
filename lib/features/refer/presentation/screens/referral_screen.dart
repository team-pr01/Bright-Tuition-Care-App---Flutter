import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/refer/data/referral_data.dart';
import 'package:btcclient/features/refer/presentation/screens/my_leads_screen.dart';
import 'package:btcclient/features/refer/presentation/screens/refer_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
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

      appBar: const CommonAppBar(title: "Refer & Earn"),

      body: Column(
        children: [
          /// SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
                top: 24,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// TITLE
                  Text(
                    "Earn Money by Referring Students",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.neutrals02,
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

                  // Extra space so last content isn't hidden
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          /// STICKY BOTTOM BUTTONS
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.25), width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  /// MY LEADS + ADD NEW LEAD
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: "My Leads",
                          variant: AppButtonVariant.outlineGray,
                          onPressed: () async {
                            await Navigator.push(
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
                          label: "Add Lead",
                          variant: AppButtonVariant.gradient,
                          onPressed: () async {
                            final result = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddLeadScreen(),
                              ),
                            );

                            if (result == true && context.mounted) {
                              AppSnackbar.show(
                                context,
                                "Lead added successfully",
                                SnackType.success,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// COPY REFERRAL LINK
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: "Copy Referral Link",
                      variant: AppButtonVariant.outlineGray,
                      icon: Icons.copy,
                      onPressed: () {
                        copyLink(context, link);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
