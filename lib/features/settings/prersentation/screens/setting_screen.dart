import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:collection/collection.dart';
import 'package:btcclient/features/auth/data/models/guardian_model.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';

import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/invoices/presentation/provider/invoice_provider.dart';

import 'package:btcclient/features/settings/prersentation/enums/setting_optoins.dart';

import 'package:btcclient/features/settings/prersentation/provider/verification_provider.dart';

import 'package:btcclient/features/settings/prersentation/widgets/contact_form.dart';
import 'package:btcclient/features/settings/prersentation/widgets/delete_form.dart';
import 'package:btcclient/features/settings/prersentation/widgets/lock_form.dart';
import 'package:btcclient/features/settings/prersentation/widgets/password_form.dart';
import 'package:btcclient/features/settings/prersentation/widgets/verification_form.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingScreen
    extends ConsumerStatefulWidget {

  final String role;

  const SettingScreen({
    super.key,
    required this.role,
  });

  @override
  ConsumerState<SettingScreen>
      createState() =>
          _SettingScreenState();
}

class _SettingScreenState
    extends ConsumerState<
        SettingScreen> {

  SettingsTab selectedTab =
      SettingsTab.contactInfo;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {

      /// ================= FETCH PROFILE =================
      await ref
          .read(profileProvider.notifier)
          .fetchProfile();

      /// ================= FETCH VERIFICATION =================
      await ref
          .read(
            verificationProvider
                .notifier,
          )
          .fetchVerification();
    });
  }

  Future<void> _refreshAll() async {

    await ref
        .read(profileProvider.notifier)
        .fetchProfile();

    await ref
        .read(
          verificationProvider
              .notifier,
        )
        .fetchVerification();
  }

  void onTabChange(
    SettingsTab tab,
  ) {

    setState(() {
      selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {

    final theme =
        Theme.of(context);

    final profile =
        ref.watch(profileProvider);
    bool isProfileLocked =
        true;

    if (profile
        is GuardianProfileModel) {

      isProfileLocked =
          profile.profileStatus ==
              "locked";

    } else if (profile
        is TutorProfileModel) {

      isProfileLocked =
          profile.profileStatus ==
              "locked";
    }

    return Scaffold(
      backgroundColor:
          AppColors.neutrals01,

      appBar:
          const CommonAppBar( 
            title: "Settings",
          ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshAll,

          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),

            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal:
                    AppSpacing.lg,
              ),

              child: ConstrainedBox(
                constraints:
                    BoxConstraints(
                  minHeight:
                      MediaQuery.of(
                        context,
                      ).size.height,
                ),

                child: Column(
                  children: [

                    const SizedBox(
                      height:
                          AppSpacing.slg,
                    ),

                    /// ================= TABS =================
                    SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal,

                      child: Row(
                        children: [

                          _buildTab(
                            "Contact Info",
                            SettingsTab
                                .contactInfo,
                          ),

                          _buildTab(
                            "Change Password",
                            SettingsTab
                                .changePassword,
                          ),

                          _buildTab(
                            "Verification",
                            SettingsTab
                                .profileVerification,
                          ),

                          _buildTab(
                            "Lock/Unlock",
                            SettingsTab
                                .profileLock,
                          ),

                          _buildTab(
                            "Delete Account",
                            SettingsTab
                                .deleteAccount,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height:
                          AppSpacing.lg,
                    ),

                    /// ================= CONTENT =================
                    _buildContent(
                      context,
                      ref,
                      theme,
                      isProfileLocked,
                    ),

                    const SizedBox(
                      height:
                          AppSpacing.xl,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
    String title,
    SettingsTab tab,
  ) {

    final isSelected =
        selectedTab == tab;

    return GestureDetector(
      onTap: () =>
          onTabChange(tab),

      child: Container(
        width: 160,

        margin:
            const EdgeInsets.only(
          right: AppSpacing.sm,
        ),

        padding:
            const EdgeInsets.all(
          AppSpacing.md,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary01
              : AppColors.neutrals04,

          borderRadius:
              BorderRadius.circular(
            AppRadius.large,
          ),
        ),

        child: Center(
          child: Text(
            title,

            textAlign:
                TextAlign.center,

            style: AppTextStyles
                .labelLarge
                .copyWith(
              color: isSelected
                  ? Colors.white
                  : AppColors
                        .neutrals02,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    bool isProfileLocked,
  ) {

    switch (selectedTab) {

      case SettingsTab.contactInfo:

        return ContactForm(
          isProfileLocked:
              isProfileLocked,
        );

      case SettingsTab.changePassword:

        return PasswordForm();

      case SettingsTab.profileVerification:
        final invoiceState = ref.watch(invoiceProvider); 
        final verificationInvoice =
    invoiceState.invoices.firstWhereOrNull(
  (invoice) =>
      invoice.invoiceType ==
      "verificationCharge",
);
        final profile =
            ref.watch(
              profileProvider,
            );

        final verification =
            ref.watch(
              verificationProvider,
            );
        print(verification.status);
        bool isVerified =
            false;

        bool hasRequested =
            false;

        if (profile
            is GuardianProfileModel) {

          isVerified =
              profile.isVerified;

          hasRequested =
              profile
                  .hasRequestedToVerify;

        } else if (profile
            is TutorProfileModel) {

          isVerified =
              profile.isVerified;

          hasRequested =
              profile
                  .hasRequestedToVerify;
        }

        return verificationForm(
          context,
          theme,
          ref,
          isVerified,
          hasRequested,
          verification.status,
          verification.addressCode,
          verificationInvoice
        );

      case SettingsTab.profileLock:

        return lockForm(
          context,
          theme,
          isProfileLocked,
        );

      case SettingsTab.deleteAccount:

        return deleteForm(
          context,
          theme,
        );
    }
  }
}