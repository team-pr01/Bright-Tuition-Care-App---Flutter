import 'package:btcclient/features/jobs/presentation/notifier/jobs_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/features/jobs/data/models/job_filter.dart';
import 'package:btcclient/features/jobs/presentation/provider/job_provider.dart';

class StatsLiveJobsSection extends ConsumerStatefulWidget {
  final Function(
    int, {
    String? status,
  }) changeTab;

  const StatsLiveJobsSection({
    super.key,
    required this.changeTab,
  });

  @override
  ConsumerState<StatsLiveJobsSection> createState() =>
      _StatsLiveJobsSectionState();
}

class _StatsLiveJobsSectionState
    extends ConsumerState<StatsLiveJobsSection> {
  final ScrollController _jobsScrollController =
      ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ref
          .read(jobsProvider.notifier)
          .fetchCounterStats();
    });
  }

  @override
  void dispose() {
    _jobsScrollController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final jobsState = ref.watch(jobsProvider);

    return Column(
      children: [
        _buildStats(
          jobsState,
        ),

        const SizedBox(
          height: 18,
        ),

        Container(
          height: 1,
          color: const Color(0xFFD6E9FE),
        ),

        const SizedBox(
          height: 14,
        ),

        _buildLiveJobsHeader(),

        const SizedBox(
          height: 10,
        ),

        _buildCities(
          jobsState.jobsByCity,
        ),
      ],
    );
  }

  // ============================================================
  // STATS
  // ============================================================

  Widget _buildStats(
    JobsState state,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),

      crossAxisCount: 2,

      crossAxisSpacing: 12,
      mainAxisSpacing: 12,

      childAspectRatio: 2.35,

      children: [
        _buildStatItem(
          icon:
              Icons.work_outline_rounded,
          value:
              state.availableJobs.toString(),
          label:
              'Live Jobs',
          iconColor:
              const Color(0xFFE91E63),
        ),

        _buildStatItem(
          icon:
              Icons.people_outline_rounded,
          value:
              state.activeTutors.toString(),
          label:
              'Active Tutors',
          iconColor:
              const Color(0xFF4CAF50),
        ),

        _buildStatItem(
          icon:
              Icons
                  .sentiment_satisfied_alt_outlined,
          value:
              state.happyGuardians.toString(),
          label:
              'Happy Guardians/Students',
          iconColor:
              const Color(0xFFFF9800),
        ),

        _buildStatItem(
          icon:
              Icons.emoji_events_outlined,
          value:
              state.averageRating
                  .toStringAsFixed(1),
          label:
              'Ratings',
          iconColor:
              const Color(0xFF2196F3),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.65,
        ),
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: iconColor,
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: AppTextStyles
                      .headlineMedium
                      .copyWith(
                    color:
                        AppColors.primary04,
                    fontWeight:
                        FontWeight.w800,
                    fontSize: 16,
                    height: 1.1,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  label,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: AppTextStyles
                      .bodySmall
                      .copyWith(
                    color:
                        AppColors.neutrals03,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w500,
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
  // LIVE JOB HEADER
  // ============================================================

  Widget _buildLiveJobsHeader() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration:
              const BoxDecoration(
            color:
                Color(0xFF2196F3),
            shape:
                BoxShape.circle,
          ),
        ),

        const SizedBox(
          width: 8,
        ),

        Expanded(
          child: Text(
            'Live Tuition Jobs',
            style: AppTextStyles
                .headlineMedium
                .copyWith(
              color:
                  AppColors.neutrals02,
              fontWeight:
                  FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),

        _buildNavButton(
          icon:
              Icons.chevron_left_rounded,
          onTap: () =>
              _scrollJobs(false),
        ),

        const SizedBox(
          width: 6,
        ),

        _buildNavButton(
          icon:
              Icons.chevron_right_rounded,
          onTap: () =>
              _scrollJobs(true),
        ),
      ],
    );
  }

  // ============================================================
  // CITY LIST
  // ============================================================

  Widget _buildCities(
    List<Map<String, dynamic>> cities,
  ) {
    // Only show cities that actually
    // have live jobs.
    final activeCities = cities
        .where(
          (city) =>
              _toInt(city['count']) > 0,
        )
        .toList();

    if (activeCities.isEmpty) {
      return const SizedBox(
        height: 40,
        child: Center(
          child: Text(
            'No live jobs available',
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ListView.separated(
        controller:
            _jobsScrollController,
        scrollDirection:
            Axis.horizontal,
        physics:
            const BouncingScrollPhysics(),
        padding:
            const EdgeInsets.only(
          right: 4,
        ),
        itemCount:
            activeCities.length,
        separatorBuilder:
            (_, __) {
          return const SizedBox(
            width: 8,
          );
        },
        itemBuilder:
            (context, index) {
          final cityData =
              activeCities[index];

          final city =
              cityData['city']
                      ?.toString() ??
                  '';

          final count =
              _toInt(
            cityData['count'],
          );

          return _buildJobPill(
            city,
            count,
          );
        },
      ),
    );
  }

  // ============================================================
  // CITY PILL
  // ============================================================

  Widget _buildJobPill(
    String city,
    int count,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(8),
        onTap: () async {
          final selectedCity =
              city.trim();

          if (selectedCity.isEmpty) {
            return;
          }

          print(
            '🏙️ SELECTED CITY: '
            '$selectedCity',
          );

          final filter = JobFilter(
            status: 'live',
            city: [
              selectedCity,
            ],
          );

          try {
            // Fetch the jobs for the
            // selected city first.
            await ref
                .read(
                  jobsProvider.notifier,
                )
                .applyFilter(
                  filter,
                );

            if (!mounted) return;

            // Job Board is tab 0.
            widget.changeTab(
              0,
              status: 'live',
            );
          } catch (e) {
            print(
              '❌ CITY JOB FILTER ERROR: $e',
            );
          }
        },
        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration:
              BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color:
                  AppColors.primary01,
            ),
            borderRadius:
                BorderRadius.circular(8),
          ),
          child: Text(
            '$city ($count)',
            style: AppTextStyles
                .bodyMedium
                .copyWith(
              color:
                  AppColors.primary01,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HORIZONTAL SCROLL
  // ============================================================

  void _scrollJobs(
    bool forward,
  ) {
    if (!_jobsScrollController
        .hasClients) {
      return;
    }

    const double amount = 180;

    final current =
        _jobsScrollController.offset;

    final max =
        _jobsScrollController
            .position
            .maxScrollExtent;

    final target = forward
        ? current + amount
        : current - amount;

    final safeTarget =
        target.clamp(0.0, max);

    _jobsScrollController
        .animateTo(
      safeTarget,
      duration:
          const Duration(
        milliseconds: 300,
      ),
      curve:
          Curves.easeInOut,
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  int _toInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  // ============================================================
  // NAV BUTTON
  // ============================================================

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape:
          const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder:
            const CircleBorder(),
        child: Container(
          width: 28,
          height: 28,
          decoration:
              BoxDecoration(
            shape:
                BoxShape.circle,
            border:
                Border.all(
              color:
                  const Color(
                0xFF2196F3,
              ),
              width: 0.6,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color:
                const Color(
              0xFF2196F3,
            ),
          ),
        ),
      ),
    );
  }
}