import 'package:btcclient/features/guest/presentation/guest_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/guest/presentation/widgets/overview_bottom_sheets.dart';

import 'package:btcclient/features/jobs/presentation/provider/job_provider.dart';
import 'package:btcclient/features/jobs/data/models/job_filter.dart';
import 'dart:async';

class OverviewScreen extends ConsumerStatefulWidget {
  //  final Function(int, {String? status}) changeTab;

  const OverviewScreen({
    super.key,
    // required this.changeTab,
  });

  @override
  ConsumerState<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends ConsumerState<OverviewScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final PageController _serviceController = PageController(
    viewportFraction: 0.99,
  );

  final ScrollController _jobsScrollController = ScrollController();
  Timer? _serviceAutoScrollTimer;

  int _currentServicePage = 0;

  // ============================================================
  // SERVICE CATEGORIES
  // ============================================================

  final List<_ServiceCategory> _categories = const [
    _ServiceCategory(
      title: "Admission Test",
      imagePath: "assets/images/service_catagories/admission_test.png",
    ),
    _ServiceCategory(
      title: "Madrasa Medium",
      imagePath: "assets/images/service_catagories/arbi.png",
    ),
    _ServiceCategory(
      title: "Bangla Medium",
      imagePath: "assets/images/service_catagories/bangla_medium.png",
    ),
    _ServiceCategory(
      title: "Drawing & Art",
      imagePath: "assets/images/service_catagories/drawing.png",
    ),
    _ServiceCategory(
      title: "English Medium",
      imagePath: "assets/images/service_catagories/english_medium.png",
    ),
    _ServiceCategory(
      title: "English Version",
      imagePath: "assets/images/service_catagories/english_version.png",
    ),
    _ServiceCategory(
      title: "Language Learning",
      imagePath: "assets/images/service_catagories/language_learning.png",
    ),
    _ServiceCategory(
      title: "Professional Skills",
      imagePath: "assets/images/service_catagories/professional_skills.png",
    ),
    _ServiceCategory(
      title: "Special Child Education",
      imagePath: "assets/images/service_catagories/special_child.png",
    ),
    _ServiceCategory(
      title: "Special Skills",
      imagePath: "assets/images/service_catagories/special_skills.png",
    ),
    _ServiceCategory(
      title: "Test Preparation",
      imagePath: "assets/images/service_catagories/test_prep.png",
    ),
    _ServiceCategory(
      title: "University Help",
      imagePath: "assets/images/service_catagories/uni_help.png",
    ),
  ];

  void _startServiceAutoScroll() {
    _serviceAutoScrollTimer?.cancel();

    _serviceAutoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_serviceController.hasClients) {
        return;
      }

      final int pageCount = (_categories.length / 2).ceil();

      if (pageCount <= 1) {
        return;
      }

      final int nextPage = (_currentServicePage + 1) % pageCount;

      _serviceController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  // ============================================================
  // STATS
  // ============================================================

  final List<_StatItem> _stats = const [
    _StatItem(
      icon: Icons.work_outline_rounded,
      value: '184',
      label: 'Live Jobs',
      iconColor: Color(0xFFE91E63),
    ),
    _StatItem(
      icon: Icons.people_outline_rounded,
      value: '40007',
      label: 'Active Tutors',
      iconColor: Color(0xFF4CAF50),
    ),
    _StatItem(
      icon: Icons.sentiment_satisfied_alt_outlined,
      value: '12223',
      label: 'Happy Guardians',
      iconColor: Color(0xFFFF9800),
    ),
    _StatItem(
      icon: Icons.emoji_events_outlined,
      value: '4.7',
      label: 'Ratings',
      iconColor: Color(0xFF2196F3),
    ),
  ];

  // ============================================================
  // JOB LOCATIONS
  // ============================================================

  // ============================================================
  // USEFUL ITEMS
  // ============================================================

  final List<_UsefulItem> _usefulItems = const [
    _UsefulItem(icon: Icons.info_outline_rounded, title: 'About Us'),
    _UsefulItem(icon: Icons.support_agent_outlined, title: 'Contact Us'),
    _UsefulItem(icon: Icons.share_rounded, title: 'Social Links'),
    _UsefulItem(icon: Icons.link_rounded, title: 'Quick Links'),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobsProvider.notifier).fetchCounterStats();
      _startServiceAutoScroll();
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _serviceAutoScrollTimer?.cancel();
    _serviceController.dispose();
    _jobsScrollController.dispose();
    super.dispose();
  }

  // ============================================================
  // JOB SCROLL
  // ============================================================

  void _scrollJobs(bool forward) {
    if (!_jobsScrollController.hasClients) {
      return;
    }

    const double scrollAmount = 180;

    final double currentOffset = _jobsScrollController.offset;

    final double maxOffset = _jobsScrollController.position.maxScrollExtent;

    final double targetOffset = forward
        ? (currentOffset + scrollAmount).clamp(0.0, maxOffset)
        : (currentOffset - scrollAmount).clamp(0.0, maxOffset);

    _jobsScrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Overview", showNotification: false),
      backgroundColor: AppColors.primary03,
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

            final double horizontalPadding = width >= 600
                ? 36.0
                : width < 360
                ? 12.0
                : 16.0;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.md,
                horizontalPadding,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // 1. TUTORING SERVICES
                  // ==================================================
                  _buildServiceCategoriesSection(),

                  const SizedBox(height: AppSpacing.lg),

                  // ==================================================
                  // 2. STATS + LIVE JOBS
                  // ==================================================
                  _buildCombinedStatsAndJobsCard(),

                  const SizedBox(height: AppSpacing.lg),

                  // ==================================================
                  // 3. USEFUL INFO
                  // ==================================================
                  _buildUsefulInfoCard(),

                  const SizedBox(height: AppSpacing.lg),

                  // ==================================================
                  // 4. FEATURED
                  // ==================================================
                  // _buildFeaturedSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // SERVICE SECTION
  // ============================================================

  Widget _buildServiceCategoriesSection() {
    // 2 service cards = 1 page
    final int servicePageCount = (_categories.length / 2).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Tutoring Services',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary04,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'Connecting students with expert tutors across all education categories.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutrals03,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ========================================================
        // SERVICE CAROUSEL — 2 CARDS PER PAGE
        // ========================================================
        SizedBox(
          width: double.infinity,
          height: 220,
          child: PageView.builder(
            controller: _serviceController,
            itemCount: servicePageCount,
            physics: const BouncingScrollPhysics(),

            onPageChanged: (index) {
              if (!mounted) return;

              setState(() {
                _currentServicePage = index;
              });
            },

            itemBuilder: (context, pageIndex) {
              // First card index of this page
              final int firstIndex = pageIndex * 2;

              // Second card index
              final int secondIndex = firstIndex + 1;

              return Row(
                children: [
                  // ==================================================
                  // FIRST SERVICE CARD
                  // ==================================================
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: _buildServiceCard(_categories[firstIndex]),
                    ),
                  ),

                  // ==================================================
                  // SECOND SERVICE CARD
                  // ==================================================
                  if (secondIndex < _categories.length)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 8),
                        child: _buildServiceCard(_categories[secondIndex]),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ========================================================
        // PAGE INDICATOR
        // ========================================================
        _buildServiceIndicator(pageCount: servicePageCount),
      ],
    );
  }

  // ============================================================
  // SERVICE INDICATOR
  // ============================================================

  Widget _buildServiceIndicator({required int pageCount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final bool isSelected = _currentServicePage == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isSelected ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary01 : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  Widget _buildServiceCard(_ServiceCategory category) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // IMAGE
          Positioned.fill(
            child: Image.asset(
              category.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                );
              },
            ),
          ),

          // GRADIENT
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.78),
                  ],
                ),
              ),
            ),
          ),

          // TITLE
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Text(
              category.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATS + LIVE JOBS CARD
  // ============================================================

  Widget _buildCombinedStatsAndJobsCard() {
    final jobsState = ref.watch(jobsProvider);

    final cities = jobsState.jobsByCity;

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          // ========================================================
          // 2 × 2 STATS
          // ========================================================
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.35,
            ),
            itemBuilder: (context, index) {
              return _buildInlineStatItem(_stats[index]);
            },
          ),

          const SizedBox(height: 18),

          Container(height: 1, color: const Color(0xFFD6E9FE)),

          const SizedBox(height: 14),

          // ========================================================
          // HEADER
          // ========================================================
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF2196F3),
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  'Live Tuition Jobs',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.neutrals02,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),

              _buildNavButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => _scrollJobs(false),
              ),

              const SizedBox(width: 6),

              _buildNavButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => _scrollJobs(true),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ========================================================
          // CITIES FROM API
          // ========================================================
          _buildCities(jobsState.jobsByCity),
        ],
      ),
    );
  }
  // ============================================================
  // STAT ITEM
  // ============================================================

  Widget _buildInlineStatItem(_StatItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(item.icon, size: 30, color: item.iconColor),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.primary04,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  item.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.neutrals03,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // JOB PILL
  // ============================================================

  Widget _buildCities(List<Map<String, dynamic>> cities) {
    // Only show cities that actually
    // have live jobs.
    final activeCities = cities
        .where((city) => _toInt(city['count']) > 0)
        .toList();

    // if (activeCities.isEmpty) {
    //   return const SizedBox(
    //     height: 40,
    //     child: Center(child: Text('No live jobs available')),
    //   );
    // }

    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ListView.separated(
        controller: _jobsScrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(right: 4),
        itemCount: cities.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final cityData = cities[index];

          final city = cityData['city']?.toString() ?? '';

          final count = _toInt(cityData['count']);

          return _buildJobPill(city, count);
        },
      ),
    );
  }

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Widget _buildJobPill(String city, int count) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        // borderRadius: BorderRadius.circular(8),
        onTap: () async {
          final selectedCity = city.trim();

          if (selectedCity.isEmpty) {
            return;
          }

          print(
            '🏙️ SELECTED CITY: '
            '$selectedCity',
          );

          final filter = JobFilter(status: 'live', city: [selectedCity]);

          try {
            // Fetch the jobs for the
            // selected city first.
            await ref.read(jobsProvider.notifier).applyFilter(filter);

            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const GuestDashboardScreen(initialIndex: 0),
              ),
            );
          } catch (e) {
            print('❌ CITY JOB FILTER ERROR: $e');
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: AppColors.primary01),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$city ($count)',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary01,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
  // ============================================================
  // NAV BUTTON
  // ============================================================

  Widget _buildNavButton({required IconData icon, VoidCallback? onTap}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color.fromARGB(188, 33, 149, 243),
              width: 0.6,
            ),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF2196F3)),
        ),
      ),
    );
  }

  // ============================================================
  // USEFUL INFO
  // ============================================================

  Widget _buildUsefulInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
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
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.neutrals02,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: _usefulItems.map((item) {
              return Expanded(child: _buildUsefulItem(item));
            }).toList(),
          ),
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
      onTap: () {
        switch (item.title) {
          case 'About Us':
            OverviewBottomSheets.showAboutUs(context);
            break;

          case 'Contact Us':
            OverviewBottomSheets.showContactUs(context);
            break;

          case 'Social Links':
            OverviewBottomSheets.showSocialLinks(context);
            break;

          case 'Quick Links':
            OverviewBottomSheets.showQuickLinks(context);
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.primary02,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, size: 26, color: AppColors.primary01),
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary04,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  } // ============================================================

  // FEATURED SECTION
  // ============================================================
}

// ================================================================
// DATA MODELS
// ================================================================

class _ServiceCategory {
  final String title;
  final String imagePath;

  const _ServiceCategory({required this.title, required this.imagePath});
}

class _StatItem {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
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
