import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/get_cout.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_nav_links.dart';
import 'package:btcclient/core/widgets/search_bar/search_bar.dart';
import 'package:btcclient/features/jobs/data/models/job_filter.dart';
import 'package:btcclient/features/jobs/presentation/enums/job_card_variant.dart';
import 'package:btcclient/features/jobs/presentation/provider/job_provider.dart';
import 'package:btcclient/features/jobs/presentation/provider/posted_job_provider.dart';
import 'package:btcclient/features/jobs/presentation/provider/selected_job_filter_provider.dart';
import 'package:btcclient/features/jobs/presentation/widgets/filter_form.dart';
import 'package:btcclient/features/jobs/presentation/widgets/job_card.dart';
import 'package:btcclient/features/jobs/presentation/widgets/skeleton/job_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:btcclient/core/services/navigation_service.dart';
import 'package:btcclient/features/jobs/presentation/enums/job_card_variant.dart';
import 'package:btcclient/features/jobs/presentation/provider/job_provider.dart';
import 'package:btcclient/features/jobs/presentation/widgets/job_bottom_sheet.dart';
import 'dart:async';

class JobsPage extends ConsumerStatefulWidget {
  final String role;
  final String? initialStatus;
  final Function(int, {String? status}) changeTab;
  const JobsPage({
    super.key,
    required this.role,
    this.initialStatus,
    required this.changeTab,
  });

  @override
  ConsumerState<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends ConsumerState<JobsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _openingNotificationJob = false;

  bool get isTutor => widget.role == "tutor";
  bool get isGuest => widget.role == "guest";

  void _checkNotificationJob() {
    if (!isTutor) {
      return;
    }

    if (_openingNotificationJob) {
      return;
    }

    final jobId = NavigationService.pendingJobId;

    if (jobId == null || jobId.isEmpty) {
      return;
    }

    debugPrint('🔔 JobsPage detected pending notification job: $jobId');

    _openPendingNotificationJob();
  }

  Future<void> _openPendingNotificationJob() async {
    if (!isTutor) {
      return;
    }

    if (_openingNotificationJob) {
      return;
    }

    final jobId = NavigationService.consumePendingJob();

    if (jobId == null || jobId.isEmpty) {
      debugPrint('ℹ️ JobsPage: no pending notification job');
      return;
    }

    debugPrint('🔔 JobsPage received notification job: $jobId');

    _openingNotificationJob = true;

    try {
      final jobsState = ref.read(jobsProvider);

      dynamic job;

      // ========================================================
      // 1. FIRST: CHECK WHETHER JOB IS ALREADY LOADED
      // ========================================================

      for (final item in jobsState.jobs) {
        final loadedJobId = item.jobId?.toString();

        if (loadedJobId == jobId) {
          job = item;
          break;
        }
      }

      // ========================================================
      // 2. IF ALREADY LOADED → OPEN IMMEDIATELY
      // ========================================================

      if (job != null) {
        debugPrint('⚡ Job $jobId already loaded → opening bottom sheet');

        if (!mounted) return;

        await _showNotificationJobSheet(job);

        return;
      }

      // ========================================================
      // 3. NOT LOADED → FETCH IT
      // ========================================================

      debugPrint('🌐 Job $jobId not loaded → fetching from API');

      final fetchedJob = await ref
          .read(jobsProvider.notifier)
          .fetchJobByCustomId(jobId);

      if (!mounted) return;

      debugPrint('✅ Notification job fetched: ${fetchedJob.jobId}');

      // ========================================================
      // 4. OPEN SAME BOTTOM SHEET
      // ========================================================

      await _showNotificationJobSheet(fetchedJob);
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to open notification job: $e');

      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _openingNotificationJob = false;
    }
  }

  Future<void> _showNotificationJobSheet(dynamic job) async {
    if (!mounted) {
      return;
    }

    debugPrint('📋 Opening JobBottomSheet for job: ${job.jobId}');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return JobBottomSheet(
          variant: JobCardVariant.job,
          job: job,
          changeTab: widget.changeTab,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isTutor || isGuest) {
        final filter = ref.read(selectedJobFilterProvider);

        await ref.read(jobsProvider.notifier).fetchJobs(newFilter: filter);
      }
      // if (!isTutor) {
      //   await ref
      //       .read(postedJobsProvider.notifier)
      //       .fetchPostedJobs(status: widget.initialStatus);

      //   return;
      // }

      // final filter = ref.read(selectedJobFilterProvider);

      // await ref.read(jobsProvider.notifier).fetchJobs(newFilter: filter);

      // --------------------------------------------------------
      // IMPORTANT:
      // Check notification AFTER Job Board is initialized.
      // --------------------------------------------------------

      // if (mounted) {
      //   await _openPendingNotificationJob();
      // }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (isTutor || isGuest) {
          ref.read(jobsProvider.notifier).loadMore();
        } else {
          ref.read(postedJobsProvider.notifier).loadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isTutor) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _checkNotificationJob();
        }
      });
    }

    final jobsState = ref.watch(jobsProvider);
    final postedState = ref.watch(postedJobsProvider);
    final state = (isTutor || isGuest) ? jobsState : postedState;

    ref.listen<JobFilter?>(selectedJobFilterProvider, (previous, next) {
      if (isTutor && next != null) {
        ref.read(jobsProvider.notifier).fetchJobs(newFilter: next);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(state),
            Expanded(child: _buildBody(state)),
          ],
        ),
      ),
    );
  }

  /// ================= TOP BAR =================
  Widget _buildTopBar(state) {
    final selectedFilter = ref.watch(selectedJobFilterProvider);
    final hasFilters =
        (selectedFilter?.city?.isNotEmpty ?? false) ||
        (selectedFilter?.area?.isNotEmpty ?? false) ||
        (selectedFilter?.category?.isNotEmpty ?? false) ||
        (selectedFilter?.className?.isNotEmpty ?? false) ||
        (selectedFilter?.curriculum?.isNotEmpty ?? false) ||
        (selectedFilter?.tutoringDays?.isNotEmpty ?? false) ||
        (selectedFilter?.preferredTutorGender?.isNotEmpty ?? false) ||
        (selectedFilter?.studentGender?.isNotEmpty ?? false) ||
        (selectedFilter?.tuitionType?.isNotEmpty ?? false) ||
        (selectedFilter?.subjects?.isNotEmpty ?? false) ||
        ((selectedFilter?.keyword?.isNotEmpty ?? false));
    void openFilter(BuildContext context) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Filter",
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) {
          return Align(
            alignment: Alignment.centerRight,
            child: FilterSidebar(),
          );
        },
        transitionBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔍 SEARCH
          if (isTutor) ...[
            ReusableSearchBar(
              controller: _searchController,
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();

                _debounce = Timer(const Duration(milliseconds: 500), () {
                  ref
                      .read(jobsProvider.notifier)
                      .fetchJobs(
                        newFilter: state.filter.copyWith(keyword: value),
                      );
                });
              },
            ),
          ],

          const SizedBox(height: 16),
          if (!isTutor && !isGuest) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DashboardNavLinks(
                  icon: SvgPicture.asset(
                    "assets/icons/navigations/appointed.svg",
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "All Jobs",
                  count: state.meta?.counts.totalJobs ?? 0,
                  onTap: () {
                    ref
                        .read(postedJobsProvider.notifier)
                        .fetchPostedJobs(status: null);
                  },
                ),

                DashboardNavLinks(
                  icon: SvgPicture.asset(
                    "assets/icons/navigations/pending-jobs.svg",
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Pending",
                  count: state.meta?.counts.pendingJobs ?? 0,
                  onTap: () {
                    ref
                        .read(postedJobsProvider.notifier)
                        .fetchPostedJobs(status: "pending");
                  },
                ),

                DashboardNavLinks(
                  icon: SvgPicture.asset(
                    "assets/icons/navigations/jobs-search.svg",
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Live",
                  count: state.meta?.counts.liveJobs ?? 0,
                  onTap: () {
                    ref
                        .read(postedJobsProvider.notifier)
                        .fetchPostedJobs(status: "live");
                  },
                ),

                DashboardNavLinks(
                  icon: SvgPicture.asset(
                    "assets/icons/navigations/confirmed.svg",
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Closed",
                  count: state.meta?.counts.closedJobs ?? 0,
                  onTap: () {
                    ref
                        .read(postedJobsProvider.notifier)
                        .fetchPostedJobs(status: "closed");
                  },
                ),

                DashboardNavLinks(
                  icon: SvgPicture.asset(
                    "assets/icons/navigations/cancelled.svg",
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Cancelled",
                  count: state.meta?.counts.cancelledJobs ?? 0,
                  onTap: () {
                    ref
                        .read(postedJobsProvider.notifier)
                        .fetchPostedJobs(status: "cancelled");
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],

          /// 📊 COUNT + FILTER
          Row(
            children: [
              Expanded(
                child: Text(
                  getCountText(
                    (isTutor || isGuest)
                        ? (state.meta?.liveJobs ?? 0)
                        : (state.meta?.counts.liveJobs ?? 0),
                  ),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.neutrals02,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),

              if (isTutor || isGuest) ...[
                /// Clear Filters
                Row(
                  children: [
                    if (hasFilters)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: AppButton(
                          iconOnly: true,
                          icon: Icons.filter_alt_off_rounded,
                          variant: AppButtonVariant.outline,
                          width: 42,
                          height: 32,
                          onPressed: () async {
                            ref.read(selectedJobFilterProvider.notifier).state =
                                JobFilter(status: "live");

                            await ref
                                .read(jobsProvider.notifier)
                                .applyFilter(JobFilter(status: "live"));
                          },
                        ),
                      ),

                    const SizedBox(width: 6),

                    AppButton(
                      label: "Filter",
                      onPressed: () => openFilter(context),
                      variant: AppButtonVariant.outline,
                      height: 32,
                      width: 130,
                      icon: Icons.tune,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// ================= BODY =================
  Widget _buildBody(state) {
    if (state.isLoading && state.jobs.isEmpty) {
      return Center(
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (_, __) => const JobCardSkeleton(),
        ),
      );
    }

    if (state.error != null && state.jobs.isEmpty) {
      return Center(child: Text(state.error ?? "Something went wrong"));
    }

    if (!state.isLoading && state.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
        'assets/icons/navigations/jobs.svg',
        width: 80,
        height: 80,
        colorFilter: const ColorFilter.mode(
                  AppColors.primary01,
                  BlendMode.srcIn,
                ),
            ),
            const SizedBox(width: 8),
            const Text(
        'No Jobs',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
            ),
          ],
        ),
      );
   ;
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (isTutor || isGuest) {
          await ref.read(jobsProvider.notifier).refresh();
        } else {
          await ref.read(postedJobsProvider.notifier).refresh();
        }
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.jobs.length + 1,
        itemBuilder: (context, index) {
          if (index == state.jobs.length) {
            return _buildPaginationLoader(state);
          }

          final job = state.jobs[index];
          print(job);
          return JobCard(
            changeTab: widget.changeTab,
            job: job,
            variant: (isTutor || isGuest)
                ? JobCardVariant.job
                : JobCardVariant.postedJob,
          );
        },
      ),
    );
  }

  /// ================= PAGINATION =================
  Widget _buildPaginationLoader(state) {
    if (state.isLoadingMore) {
      return Center(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (_, __) => const JobCardSkeleton(),
        ),
      );
    }

    if (!state.hasMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text("No more jobs")),
      );
    }

    return const SizedBox();
  }
}
