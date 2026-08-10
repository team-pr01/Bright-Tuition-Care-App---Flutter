import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/auth/presentation/screens/welcome_screen.dart';
import 'package:btcclient/features/invoices/presentation/provider/invoice_provider.dart';
import 'package:btcclient/features/legal/presentation/terms_screen.dart';
import 'package:btcclient/features/settings/prersentation/screens/change_password_screen.dart';
import 'package:btcclient/features/settings/prersentation/screens/contact_info_screen.dart';
import 'package:btcclient/features/settings/prersentation/screens/delete_account_screen.dart';
import 'package:btcclient/features/settings/prersentation/screens/profile_lock_screen.dart';
import 'package:btcclient/features/settings/prersentation/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.neutrals01,
      appBar: const CommonAppBar(title: "Settings & Activity"),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          /// ================= ACCOUNT =================
          _SectionTitle("How to use Account"),

          _SettingsTile(
            icon: Icons.phone_outlined,
            title: "Update Phone Number",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactInfoScreen(),
                ),
              );
            },
          ),

          _SettingsTile(
            icon: Icons.key_outlined,
            title: "Change Password",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),

          _SettingsTile(
            icon: Icons.verified_outlined,
            title: "Profile Verification",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VerificationScreen(),
                ),
              );
            },
          ),

          _SettingsTile(
            icon: Icons.lock_outline,
            title: "Profile Lock/Unlock",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileLockScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          /// ================= LEGAL =================
          _SectionTitle("Legal & Policies"),

          // _SettingsTile(
          //   icon: Icons.menu_book_outlined,
          //   title: "Tutor Guidelines",
          //   onTap: () {},
          // ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: "Terms & Conditions",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsScreen()),
              );
            },
          ),

          const SizedBox(height: 12),

          /// ================= SUPPORT =================
          _SectionTitle("Support"),

          _SettingsTile(
            icon: Icons.chat_outlined,
            title: "WhatsApp Support",
            onTap: () {
              launchUrl(Uri.parse("https://wa.me/8801610785588"));
            },
          ),

          _SettingsTile(
            icon: Icons.contact_mail_outlined,
            title: "Contact Us",
            onTap: () {
              launchUrl(
                Uri.parse("https://www.brighttuitioncare.com/contact-us"),
              );
            },
          ),

          const SizedBox(height: 12),

          /// ================= ACCOUNT ACTIONS =================
          _SectionTitle("Account Actions"),

          _SettingsTile(
            icon: Icons.logout,
            title: "Logout",
            onTap: () async {
              await ref.read(authProvider.notifier).logout();

              ref.read(invoiceProvider.notifier).clear();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
              );
            },
          ),

          _SettingsTile(
            icon: Icons.delete_outline,
            title: "Delete Account",
            isDanger: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeleteAccountScreen()),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        10,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.neutrals03,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDanger;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 56,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: isDanger
                          ? AppColors.error02
                          : AppColors.neutrals02,
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: isDanger
                              ? AppColors.error02
                              : AppColors.neutrals02,
                        ),
                      ),
                    ),

                    Icon(
                      Icons.chevron_right,
                      size: 22,
                      color: AppColors.neutrals03,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
