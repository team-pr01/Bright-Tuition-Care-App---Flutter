import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final PageController _heroController = PageController(viewportFraction: 0.86);

  int _currentHeroPage = 0;

  // ============================================================
  // HERO IMAGES
  // ============================================================
  //
  // Replace these with your actual Flutter asset paths.
  //
  final List<String> _heroImages = const [
    'assets/images/hero_img_4.png',
    'assets/images/hero_img_1.png',
    'assets/images/hero_img_3.png',
    'assets/images/hero_img_2.png',
  ];

  // ============================================================
  // COUNTER DATA
  // ============================================================

  final List<_StatItem> _stats = const [
    _StatItem(
      icon: Icons.work_outline_rounded,
      value: '5,742',
      label: 'Live Tuition Jobs',
    ),
    _StatItem(
      icon: Icons.person_outline_rounded,
      value: '25,000+',
      label: 'Active Tutors',
    ),
    _StatItem(
      icon: Icons.sentiment_satisfied_alt_outlined,
      value: '12,000+',
      label: 'Happy Guardians/Students',
    ),
    _StatItem(
      icon: Icons.emoji_events_outlined,
      value: '4.7',
      label: 'Ratings',
    ),
  ];

  // ============================================================
  // JOB LOCATIONS
  // ============================================================

  final List<_JobLocation> _jobLocations = const [
    _JobLocation(city: 'Dhaka', count: '311'),
    _JobLocation(city: 'Gazipur', count: '141'),
    _JobLocation(city: 'Mymensingh', count: '115'),
    _JobLocation(city: 'Chattogram', count: '96'),
    _JobLocation(city: 'Sylhet', count: '74'),
  ];

  // ============================================================
  // USEFUL INFO
  // ============================================================

  final List<_UsefulItem> _usefulItems = const [
    _UsefulItem(icon: Icons.info_outline_rounded, title: 'About Us'),
    _UsefulItem(icon: Icons.support_agent_outlined, title: 'Contact Us'),
    _UsefulItem(icon: Icons.public_rounded, title: 'Social Links'),
    _UsefulItem(icon: Icons.link_rounded, title: 'Quick Links'),
  ];

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary03,
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final horizontalPadding = width >= 600
                ? 40.0
                : width < 360
                ? 16.0
                : 22.0;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.md,
                horizontalPadding,
                AppSpacing.xl,
              ),
              child: Column(
                children: [
                  // ==================================================
                  // HERO
                  // ==================================================
                  _buildHeroSection(context),

                  const SizedBox(height: AppSpacing.lg),

                  // ==================================================
                  // HERO INDICATOR
                  // ==================================================
                  _buildHeroIndicator(),

                  const SizedBox(height: AppSpacing.lg),

                  // ==================================================
                  // COUNTER
                  // ==================================================
                  _buildStatsCard(context),

                  const SizedBox(height: AppSpacing.lg),

                  // ==================================================
                  // LIVE TUITION JOBS
                  // ==================================================
                  _buildSectionTitle('Live Tuition Jobs'),

                  const SizedBox(height: AppSpacing.sm),

                  _buildJobLocations(),

                  const SizedBox(height: AppSpacing.lg),

                  // ==================================================
                  // USEFUL INFO
                  // ==================================================
                  _buildUsefulInfoCard(context),

                  const SizedBox(height: AppSpacing.lg),

                  // ==================================================
                  // FEATURED / TRUST
                  // ==================================================
                  _buildFeaturedSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HERO SECTION
  // ============================================================

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // // ----------------------------------------------------------
        // // WHATSAPP
        // // ----------------------------------------------------------
        // GestureDetector(
        //   onTap: () async {
        //     final Uri uri = Uri.parse('https://wa.me/8801610785588');

        //     if (await canLaunchUrl(uri)) {
        //       await launchUrl(uri, mode: LaunchMode.externalApplication);
        //     }
        //   },
        //   child: Row(
        //     children: [
        //       const Icon(Icons.chat, size: 21, color: Colors.green),
        //       const SizedBox(width: AppSpacing.sm),
        //       Text(
        //         '+880 1610-785588',
        //         style: AppTextStyles.titleMedium.copyWith(
        //           color: AppColors.neutrals02,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        // const SizedBox(height: AppSpacing.md),

        // // ----------------------------------------------------------
        // // HERO HEADING
        // // ----------------------------------------------------------
        // RichText(
        //   text: TextSpan(
        //     style: AppTextStyles.displaySmall.copyWith(
        //       color: AppColors.neutrals02,
        //       fontWeight: FontWeight.w700,
        //       height: 1.15,
        //     ),
        //     children: [
        //       const TextSpan(text: 'Find The Best '),
        //       TextSpan(
        //         text: 'Tutor',
        //         style: AppTextStyles.displaySmall.copyWith(
        //           color: AppColors.primary01,
        //           fontWeight: FontWeight.w700,
        //           height: 1.15,
        //         ),
        //       ),
        //       const TextSpan(text: ' Today'),
        //     ],
        //   ),
        // ),

        // const SizedBox(height: AppSpacing.sm),

        // // ----------------------------------------------------------
        // // DESCRIPTION
        // // ----------------------------------------------------------
        // Text(
        //   'Easily connect with experienced and verified tutors '
        //   'for any subject or class and ensuring the effective '
        //   'learning support for your child.',
        //   style: AppTextStyles.bodyLarge.copyWith(
        //     color: AppColors.neutrals06,
        //     height: 1.5,
        //   ),
        // ),

        // const SizedBox(height: AppSpacing.lg),

        // // ----------------------------------------------------------
        // // CTA + SIGNUP
        // // ----------------------------------------------------------
        // LayoutBuilder(
        //   builder: (context, constraints) {
        //     if (constraints.maxWidth < 450) {
        //       return Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           _buildFindTutorButton(),

        //           const SizedBox(height: AppSpacing.md),

        //           _buildTutorSignupText(),
        //         ],
        //       );
        //     }

        //     return Row(
        //       children: [
        //         _buildFindTutorButton(),
        //         const SizedBox(width: AppSpacing.md),
        //         Expanded(child: _buildTutorSignupText()),
        //       ],
        //     );
        //   },
        // ),

        // const SizedBox(height: AppSpacing.lg),

        // // ----------------------------------------------------------
        // // HERO IMAGE CAROUSEL
        // // ----------------------------------------------------------
         SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _heroController,
            itemCount: _heroImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentHeroPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: _buildHeroImage(_heroImages[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HERO IMAGE
  // ============================================================

  Widget _buildHeroImage(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary04.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,

        // Prevent the whole screen from breaking
        // if an asset hasn't been added yet.
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryGradientStart, AppColors.primary01],
              ),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, size: 55, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // FIND TUTOR BUTTON
  // ============================================================

  Widget _buildFindTutorButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          // TODO:
          // Navigate to tutor search screen.
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary01,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
        child: const Text(
          'Find a Tutor',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ============================================================
  // TUTOR SIGNUP
  // ============================================================

  Widget _buildTutorSignupText() {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutrals06),
        children: [
          const TextSpan(text: 'Want to become a Tutor? '),
          TextSpan(
            text: 'Sign Up',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary01,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(text: ' now'),
        ],
      ),
    );
  }

  // ============================================================
  // HERO INDICATOR
  // ============================================================

  Widget _buildHeroIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_heroImages.length, (index) {
        final selected = index == _currentHeroPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: selected ? 15 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary01 : AppColors.neutrals05,
            borderRadius: BorderRadius.circular(9999),
          ),
        );
      }),
    );
  }

  // ============================================================
  // STATS CARD
  // ============================================================

  Widget _buildStatsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutrals01,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary04.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatItem(_stats[0])),

              _buildVerticalDivider(),

              Expanded(child: _buildStatItem(_stats[1])),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          _buildHorizontalDivider(),

          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(child: _buildStatItem(_stats[2])),

              _buildVerticalDivider(),

              Expanded(child: _buildStatItem(_stats[3])),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STAT ITEM
  // ============================================================

  Widget _buildStatItem(_StatItem item) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary02,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Icon(item.icon, size: 31, color: AppColors.primary01),
        ),

        const SizedBox(width: AppSpacing.sm),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary04,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                item.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutrals03,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DIVIDERS
  // ============================================================

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 68,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      color: AppColors.neutrals04,
    );
  }

  Widget _buildHorizontalDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.neutrals04,
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: AppTextStyles.headlineLarge.copyWith(
        color: AppColors.neutrals02,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ============================================================
  // LIVE TUITION JOBS
  // ============================================================

  Widget _buildJobLocations() {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _jobLocations.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: AppSpacing.sm);
        },
        itemBuilder: (context, index) {
          final item = _jobLocations[index];

          return Container(
            constraints: const BoxConstraints(minWidth: 145),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.neutrals01,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary04.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              '${item.city} ${item.count}',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.neutrals06,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // USEFUL INFO
  // ============================================================

  Widget _buildUsefulInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutrals01,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary04.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Useful Info',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.neutrals02,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: _usefulItems.map((item) {
              return Expanded(child: _buildUsefulItem(item));
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            'We were featured on',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.neutrals02,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     _buildFeaturedLogo(Icons.school_outlined),
          //     _buildFeaturedLogo(Icons.business_outlined),
          //     _buildFeaturedLogo(Icons.public_outlined),
          //   ],
          // ),
        ],
      ),
    );
  }

  // ============================================================
  // USEFUL ITEM
  // ============================================================

  Widget _buildUsefulItem(_UsefulItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: AppColors.primary02,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, size: 29, color: AppColors.primary01),
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary04,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FEATURED
  // ============================================================

  Widget _buildFeaturedSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.neutrals01,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Column(
        children: [
          Text(
            'Trusted by learners and tutors',
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.neutrals02,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              _buildLogoPlaceholder(Icons.school_outlined, 'Education'),
              _buildLogoPlaceholder(Icons.business_outlined, 'Partners'),
              _buildLogoPlaceholder(Icons.public_outlined, 'Community'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoPlaceholder(IconData icon, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 36, color: AppColors.primary04),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.neutrals03,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedLogo(String imagePath) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Image.asset(
            imagePath,
            height: 45,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 45,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.neutrals03,
                    size: 28,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ================================================================
// MODELS
// ================================================================

class _StatItem {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });
}

class _JobLocation {
  final String city;
  final String count;

  const _JobLocation({required this.city, required this.count});
}

class _UsefulItem {
  final IconData icon;
  final String title;

  const _UsefulItem({required this.icon, required this.title});
}
