import 'package:btcclient/core/screens/join_community.dart';
import 'package:btcclient/core/widgets/helpline_card/helpline_card.dart';
import 'package:btcclient/core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import 'package:btcclient/features/auth/presentation/screens/register_screen.dart';
import 'package:btcclient/features/legal/presentation/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:btcclient/core/config/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewBottomSheets {
  // ==============================================================
  // SHOW ABOUT US
  // ==============================================================

  static void showAboutUs(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const ReusableBottomSheet(child: AboutUsContent());
      },
    );
  }

  // ==============================================================
  // SHOW CONTACT US
  // ==============================================================

  static void showContactUs(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const ReusableBottomSheet(child: ContactUsContent());
      },
    );
  }

  // ==============================================================
  // SHOW SOCIAL LINKS
  // ==============================================================

  static void showSocialLinks(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const ReusableBottomSheet(child: SocialLinksContent());
      },
    );
  }

  // ==============================================================
  // SHOW QUICK LINKS
  // ==============================================================

  static void showQuickLinks(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const ReusableBottomSheet(child: QuickLinksContent());
      },
    );
  }
}

// ==================================================================
// COMMON TITLE
// ==================================================================

class _BottomSheetTitle extends StatelessWidget {
  final String title;

  const _BottomSheetTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.primary01,
          fontWeight: FontWeight.w500,
          fontSize: 16,
          height: 1.2,
          decorationColor: AppColors.primary01,
          decorationThickness: 1.5,
        ),
      ),
    );
  }
}

// ==================================================================
// ABOUT US
// ==================================================================

class AboutUsContent extends StatelessWidget {
  const AboutUsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ============================================================
        // ABOUT BRIGHT TUITION CARE
        // ============================================================
        Container(
          width: double.infinity,
          // padding: const EdgeInsets.all(16),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(18),
          //   border: Border.all(color: const Color(0xFFE3E8EC), width: 1),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.black.withOpacity(0.04),
          //       blurRadius: 12,
          //       offset: const Offset(0, 4),
          //     ),
          //   ],
          // ),
          child: Column(
            children: [
              // --------------------------------------------------------
              // LOGO
              // --------------------------------------------------------
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary02, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary01.withOpacity(0.12),
                      blurRadius: 18,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  'assets/images/logo-1.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.school_rounded,
                      size: 42,
                      color: AppColors.primary01,
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),
              const _BottomSheetTitle(title: 'About Bright Tuition Care'),
              // --------------------------------------------------------
              // DESCRIPTION
              // --------------------------------------------------------
              Text(
                '''Bright Tuition Care is Bangladesh's first and most trusted platform for "guardians, students and tutors" to connect with verified tutors and find tuition jobs across the country. We are dedicated to bridging the educational gap between students and tutors. Our mission is to provide a trusted platform where guardians, students and tutors can connect easily.''',
                textAlign: TextAlign.justify,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutrals03,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // ============================================================
        // COMPANY INFORMATION
        // ============================================================
        Text(
          'Company Info',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary01,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            height: 1.2,
            decorationColor: AppColors.primary01,
            decorationThickness: 1.5,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(16),
          //   border: Border.all(color: const Color(0xFFE0E5E9), width: 1),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.black.withOpacity(0.035),
          //       blurRadius: 10,
          //       offset: const Offset(0, 3),
          //     ),
          //   ],
          // ),
          child: Column(
            children: [
              const _CompanyInfoRow(
                icon: Icons.description_outlined,
                text: 'Trade License No: TRAD/DNCC/017918/2023',
              ),

              const _CompanyInfoDivider(),

              const _CompanyInfoRow(
                icon: Icons.verified_outlined,
                text: 'E-TIN Number: 435024284395',
              ),

              const _CompanyInfoDivider(),

              const _CompanyInfoRow(
                icon: Icons.barcode_reader,
                text: 'BIN Number: 003669024-010',
              ),
            ],
          ),
        ),

        // ============================================================
        // COPYRIGHT
        // ============================================================
        Container(
          width: double.infinity,
          // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          // decoration: BoxDecoration(
          //   color: AppColors.primary02.withOpacity(0.35),
          //   borderRadius: BorderRadius.circular(14),
          // ),
          child: Column(
            children: [
              //       Text(
              //         'Bright Tuition Care',
              //         textAlign: TextAlign.center,
              //         style: AppTextStyles.bodyMedium.copyWith(
              //           color: AppColors.primary01,
              //           fontWeight: FontWeight.w700,
              //           fontSize: 14,
              //         ),
              //       ),
              const SizedBox(height: 14),
              Text(
                'All Rights Reserved by Bright Tuition Care © 2026',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutrals03,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // ============================================================
        // DISCLAIMER
        // ============================================================
        Container(
          width: double.infinity,
          // padding: const EdgeInsets.all(16),
          // decoration: BoxDecoration(
          //   color: const Color(0xFFF8F9FA),
          //   borderRadius: BorderRadius.circular(16),
          //   border: Border.all(color: const Color(0xFFE5E7E9), width: 1),
          // ),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.neutrals03,
                fontSize: 12,
                height: 1.6,
              ),
              children: const [
                TextSpan(
                  text: 'Disclaimer\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary01,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text:
                      'Bright Tuition Care is an online platform that connects learners with tutors. Bright Tuition Care does not provide tuition services directly, nor does it assign or recommend specific tutors to learners. Instead, Bright Tuition Care facilitates the process by leveraging technology and security measures to help learners connect with verified and skilled tutors.',
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}

// ==================================================================
// COMPANY INFO ROW
// ==================================================================

class _CompanyInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CompanyInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primary02,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: AppColors.primary01, size: 18),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutrals03,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// COMPANY INFO DIVIDER
// ==================================================================

class _CompanyInfoDivider extends StatelessWidget {
  const _CompanyInfoDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: Color(0xFFE5E5E5));
  }
}

// ==================================================================
// CONTACT US
// ==================================================================

class ContactUsContent extends StatelessWidget {
  const ContactUsContent({super.key});

  // ================================================================
  // OPEN URL SAFELY
  // ================================================================
  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open this link.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open this link.')),
        );
      }
    }
  }

  // ================================================================
  // OPEN PHONE
  // ================================================================
  Future<void> _callNumber(BuildContext context, String number) async {
    await _openUrl(context, 'tel:$number');
  }

  // ================================================================
  // OPEN WHATSAPP
  // ================================================================
  Future<void> _openWhatsApp(BuildContext context) async {
    await _openUrl(context, 'https://wa.me/8801616012365');
  }

  // ================================================================
  // OPEN EMAIL
  // ================================================================
  Future<void> _sendEmail(BuildContext context) async {
    await _openUrl(context, 'mailto:brighttuitioncare@gmail.com');
  }

  // ================================================================
  // OPEN GOOGLE MAPS
  // ================================================================
  Future<void> _openLocation(BuildContext context) async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=Noorjahan+Road,+Mohammadpur,+Dhaka-1207',
    );

    await _openUrl(context, googleMapsUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ============================================================
        // OFFICE ADDRESS
        // ============================================================
        const _BottomSheetTitle(title: 'Office Address'),

        const SizedBox(height: 14),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF5FF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary02),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOCATION ICON
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary01,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // ADDRESS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bright Tuition Care',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.neutrals02,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Noorjahan Road, Mohammadpur, Dhaka-1207',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.neutrals03,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    OutlinedButton.icon(
                      onPressed: () {
                        _openLocation(context);
                      },
                      icon: const Icon(Icons.directions_outlined, size: 18),
                      label: const Text('Open Location'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary01,
                        side: const BorderSide(color: AppColors.primary01),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 26),

        // ============================================================
        // CONTACT US
        // ============================================================
        Text(
          'Contact Us',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary01,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            height: 1.2,
            decorationColor: AppColors.primary01,
            decorationThickness: 1.5,
          ),
        ),

        const SizedBox(height: 14),

        // ============================================================
        // WHATSAPP
        // ============================================================
        _ContactActionItem(
          icon: SvgPicture.asset(
            "assets/icons/social_media/whatsapp.svg",
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              Color.fromARGB(255, 58, 211, 101),
              BlendMode.srcIn,
            ),
          ),
          iconColor: const Color(0xFF25D366),
          title: 'WhatsApp',
          value: '+880 1616-012 365',
          onTap: () {
            _openWhatsApp(context);
          },
        ),

        const SizedBox(height: 10),

        // ============================================================
        // PHONE 1
        // ============================================================
        _ContactActionItem(
          icon: SvgPicture.asset(
            "assets/icons/navigations/mdi-light_phone.svg",
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
          iconColor: AppColors.primary01,
          title: 'Phone',
          value: '09617-785588',
          onTap: () {
            _callNumber(context, '09617785588');
          },
        ),

        const SizedBox(height: 10),

        // ============================================================
        // PHONE 2
        // ============================================================
        _ContactActionItem(
          icon: SvgPicture.asset(
            "assets/icons/navigations/mdi-light_phone.svg",
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),
          iconColor: AppColors.primary01,
          title: 'Mobile',
          value: '+880 1610-785588',
          onTap: () {
            _callNumber(context, '+8801610785588');
          },
        ),

        const SizedBox(height: 10),

        // ============================================================
        // EMAIL
        // ============================================================
        _ContactActionItem(
          icon: const Icon(
            Icons.email_outlined,
            color: Color(0xFFE05A47),
            size: 21,
          ),
          iconColor: const Color(0xFFE05A47),
          title: 'Email',
          value: 'brighttuitioncare@gmail.com',
          onTap: () {
            _sendEmail(context);
          },
        ),
        const SizedBox(height: 18),

        // ============================================================
        // HELPLINE
        // ============================================================
        HelplineCard(
          phone: '+880 1616-012 365',
          timing: '10:00 AM - 10:00 PM',
          onTap: () {
            _callNumber(context, '+8801616012365');
          },
        ),
      ],
    );
  }
}

// ====================================================================
// CONTACT ACTION ITEM
// ====================================================================

class _ContactActionItem extends StatelessWidget {
  final Widget icon;
  final Color iconColor;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _ContactActionItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE5E8EB)),
          ),
          child: Row(
            children: [
              // ICON
              Container(
                padding: EdgeInsets.all(8),
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: icon,
              ),

              const SizedBox(width: 12),

              // TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutrals03,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      value,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.neutrals02,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // ARROW
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.neutrals03,
              ),
            ],
          ),
        ),
      ),
    );
  }
} // ==================================================================
// CONTACT ITEM
// ==================================================================

// ==================================================================
// SOCIAL LINKS
// ==================================================================

class SocialLinksContent extends StatelessWidget {
  const SocialLinksContent({super.key});

  Future<void> _openSocialLink(BuildContext context, String url) async {
    final uri = Uri.parse(url);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open this social media link.'),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open this social media link.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final socials = [
      const _SocialItem(
        title: 'Facebook',
        assetPath: 'assets/icons/social_media/facebook2.svg',
        url: 'https://www.facebook.com/brighttuitioncare',
      ),
      const _SocialItem(
        title: 'Instagram',
        assetPath: 'assets/icons/social_media/instagram2.svg',
        url: 'https://www.instagram.com/brighttuitioncare',
      ),
      const _SocialItem(
        title: 'YouTube',
        assetPath: 'assets/icons/social_media/youtube2.svg',
        url: 'https://www.youtube.com/@brighttuitioncare',
      ),
      const _SocialItem(
        title: 'LinkedIn',
        assetPath: 'assets/icons/social_media/linkedin2.svg',
        url: 'https://www.linkedin.com/company/bright-tuition-care',
      ),
      const _SocialItem(
        title: 'TikTok',
        assetPath: 'assets/icons/social_media/tiktok.svg',
        url: 'https://www.tiktok.com/@brighttuitioncare',
      ),
      const _SocialItem(
        title: 'X',
        assetPath: 'assets/icons/social_media/twitter.svg',
        url: 'https://x.com/brighttuitioncare',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _BottomSheetTitle(title: 'Follow Us'),

        const SizedBox(height: 8),

        Text(
          'Stay connected with Bright Tuition Care on social media.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.neutrals03,
            fontSize: 13,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 20),

        // ============================================================
        // SOCIAL MEDIA GRID
        // ============================================================
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: socials.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final item = socials[index];

            return _SocialCard(
              item: item,
              onTap: () {
                _openSocialLink(context, item.url);
              },
            );
          },
        ),

        const SizedBox(height: 30),

        // ============================================================
        // JOIN COMMUNITY
        // ============================================================
        Text(
          'Join Our Community ',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary01,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _CommunityCard(
                icon: Icons.groups_rounded,
                title: 'Tutors',
                subtitle: 'Community',
                color: const Color(0xFF3BC4B6),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CommunityPage(
                        title: "Tutor Community",
                        description:
                            "Join our tutor community to exchange teaching strategies, gain valuable insights, stay informed on the latest trends and access resources that support your professional growth.",
                        buttonText: "Join Community",
                        link: "https://www.facebook.com/groups/252670130864095",
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _CommunityCard(
                icon: Icons.groups_rounded,
                title: 'Guardians',
                subtitle: 'Community',
                color: const Color(0xFF1976C9),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CommunityPage(
                        title: "Guardian Community",
                        description:
                            "Join the Guardian Community to share your feedback, stay connected with our team and receive important updates and expert guidance to support your child’s learning.",
                        buttonText: "Join Community",
                        link: "https://www.facebook.com/groups/248374924778212",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ==================================================================
// SOCIAL ITEM
// ==================================================================

class _SocialItem {
  final String title;
  final String assetPath;
  final String url;

  const _SocialItem({
    required this.title,
    required this.assetPath,
    required this.url,
  });
}

// ==================================================================
// SOCIAL CARD
// ==================================================================

class _SocialCard extends StatelessWidget {
  final _SocialItem item;
  final VoidCallback onTap;

  const _SocialCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.primary02.withValues(alpha: 0.35),
        highlightColor: AppColors.primary02.withValues(alpha: 0.15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE4E7EA), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ========================================================
              // REAL SOCIAL MEDIA ICON
              // ========================================================
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.primary02.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(13),
                child: SvgPicture.asset(
                  item.assetPath,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 10),

              // ========================================================
              // PLATFORM NAME
              // ========================================================
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutrals02,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// COMMUNITY CARD
// ================================================================

class _CommunityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CommunityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 36),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.neutrals02,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.neutrals02,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 4),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.neutrals03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickLinksContent extends StatelessWidget {
  const QuickLinksContent({super.key});

  // void _navigateToPage(BuildContext context, Widget page) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  // }

  @override
  Widget build(BuildContext context) {
    final links = [
      const _QuickLinkItem(
        icon: Icons.description_outlined,
        title: 'Terms and Conditions',
      ),
      const _QuickLinkItem(
        icon: Icons.school_outlined,
        title: 'Become a Tutor',
      ),
      const _QuickLinkItem(
        icon: Icons.person_add_alt_1_outlined,
        title: 'Hire a Tutor',
      ),
      const _QuickLinkItem(
        icon: Icons.play_circle_outline_rounded,
        title: 'Tutorial',
      ),
      const _QuickLinkItem(icon: Icons.help_outline_rounded, title: 'FAQ'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _BottomSheetTitle(title: 'Quick Links'),

        const SizedBox(height: 14),

        Container(
          width: double.infinity,
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(18),
          //   border: Border.all(
          //     color: const Color(0xFFE0E0E0),
          //   ),
          // ),
          child: Column(
            children: List.generate(links.length, (index) {
              final item = links[index];

              return Column(
                children: [
                  _QuickLinkRow(
                    item: item,
                    onTap: () {
                      // Close the bottom sheet first.
                      Navigator.of(context).pop();

                      // Navigate directly to the required page.
                      switch (item.title) {
                        case 'Terms and Conditions':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TermsScreen(),
                            ),
                          );
                          break;

                        case 'Become a Tutor':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterScreen(role: "tutor"),
                            ),
                          );

                          break;

                        case 'Hire a Tutor':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterScreen(role: "guardian"),
                            ),
                          );

                          break;
                        case 'Tutorial':
                          launchUrl(
                            Uri.parse(
                              'https://www.brighttuitioncare.com/tutorial',
                            ),
                          );
                          break;
                        case 'FAQ':
                          launchUrl(
                            Uri.parse('https://www.brighttuitioncare.com/faqs'),
                          );
                          break;
                      }
                    },
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
// ============================================================================
// QUICK LINK ITEM
// ============================================================================

class _QuickLinkItem {
  final IconData icon;
  final String title;

  const _QuickLinkItem({required this.icon, required this.title});
}

// ============================================================================
// QUICK LINK ROW
// ============================================================================

class _QuickLinkRow extends StatelessWidget {
  final _QuickLinkItem item;
  final VoidCallback onTap;

  const _QuickLinkRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: AppColors.primary02.withValues(alpha: 0.35),
        highlightColor: AppColors.primary02.withValues(alpha: 0.15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          child: Row(
            children: [
              // ============================================================
              // ICON
              // ============================================================
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary02,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: AppColors.primary01, size: 18),
              ),

              const SizedBox(width: 16),

              // ============================================================
              // TITLE
              // ============================================================
              Expanded(
                child: Text(
                  item.title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.neutrals02,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // ============================================================
              // ARROW
              // ============================================================
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.neutrals03,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
