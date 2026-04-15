import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/get_cout.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_nav_links.dart';
import 'package:btcclient/core/widgets/search_bar/search_bar.dart';
import 'package:btcclient/features/jobs/presentation/enums/job_card_variant.dart';
import 'package:btcclient/features/jobs/presentation/notifier/posted_jobs_notifier.dart';
import 'package:btcclient/features/jobs/presentation/provider/job_provider.dart';
import 'package:btcclient/features/jobs/presentation/provider/posted_job_provider.dart';
import 'package:btcclient/features/jobs/presentation/widgets/filter_form.dart';
import 'package:btcclient/features/jobs/presentation/widgets/job_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

class JobsPage extends ConsumerStatefulWidget {
  final String role;
  final String? initialStatus;
  const JobsPage({super.key, required this.role,  this.initialStatus,});

  @override
  ConsumerState<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends ConsumerState<JobsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool get isTutor => widget.role == "tutor";

  @override
  void initState() {
    super.initState();

    /// 🔥 INITIAL FETCH (ROLE BASED)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isTutor) {
        ref.read(jobsProvider.notifier).fetchJobs();
      } else {
        ref.read(postedJobsProvider.notifier)
        .fetchPostedJobs(status: widget.initialStatus);
      }
    });

    /// 🔥 PAGINATION
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (isTutor) {
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
    /// 🔥 SWITCH STATE BASED ON ROLE
    final jobsState = ref.watch(jobsProvider);
    final postedState = ref.watch(postedJobsProvider);

    final state = isTutor ? jobsState : postedState;
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
            child: FilterSidebar(
              onApply: (filter) {
                if (isTutor) {
                  ref.read(jobsProvider.notifier).applyFilter(filter);
                } else {
                  /// 🔥 POSTED JOB FILTER
                  ref
                      .read(postedJobsProvider.notifier)
                      .fetchPostedJobs(status: filter.status);
                }
              },
            ),
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
          if (!isTutor) ...[
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
                    isTutor
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

              if (isTutor) ...[
                AppButton(
                  label: "Filter",
                  onPressed: () => openFilter(context),
                  variant: AppButtonVariant.outline,
                  height: 32,
                  width: 130,
                  icon: Icons.tune,
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
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.jobs.isEmpty) {
      return Center(child: Text(state.error ?? "Something went wrong"));
    }

    if (!state.isLoading && state.jobs.isEmpty) {
      return const Center(child: Text("No jobs found"));
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (isTutor) {
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
            job: job,
            variant: isTutor ? JobCardVariant.job : JobCardVariant.postedJob,
          );
        },
      ),
    );
  }

  /// ================= PAGINATION =================
  Widget _buildPaginationLoader(state) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
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
