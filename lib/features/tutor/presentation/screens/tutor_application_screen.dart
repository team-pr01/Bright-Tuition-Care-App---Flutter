import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/services/navigation_service.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_nav_links.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/jobs/data/models/application_modal.dart';
import 'package:btcclient/features/jobs/presentation/enums/job_card_variant.dart';
import 'package:btcclient/features/jobs/presentation/provider/application_provider.dart';
import 'package:btcclient/features/jobs/presentation/widgets/job_bottom_sheet.dart';
import 'package:btcclient/features/jobs/presentation/widgets/job_card.dart';
import 'package:btcclient/features/jobs/presentation/widgets/skeleton/job_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyApplicationPage extends ConsumerStatefulWidget {
  final String? initialStatus;
  final Function(int, {String? status}) changeTab;

  const MyApplicationPage({
    super.key,
    this.initialStatus,
    required this.changeTab,
  });

  @override
  ConsumerState<MyApplicationPage> createState() => _MyApplicationPageState();
}

class _MyApplicationPageState extends ConsumerState<MyApplicationPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _openingNotificationApplication = false;
  late String _selectedStatus;
  @override
  void initState() {
    super.initState();

    _selectedStatus = widget.initialStatus ?? "applied";

    NavigationService.registerApplicationDetailsHandler(
      _openNotificationApplication,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(applicationsProvider.notifier)
          .fetchApplications(
            status: _selectedStatus == "applied" ? "" : _selectedStatus,
          );
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(applicationsProvider.notifier).loadMore();
      }
    });
  }

  Future<void> _openNotificationApplication(
    String jobId,
    String applicationId, {
    String? status,
  }) async {
    if (_openingNotificationApplication) return;

    _openingNotificationApplication = true;

    try {
      final targetStatus = status != null && status.isNotEmpty
          ? status
          : _selectedStatus;

      debugPrint(
        '📋 Opening application from notification: '
        'jobId=$jobId, '
        'applicationId=$applicationId, '
        'status=$targetStatus',
      );

      // 1. Look for the application in the current list first
      final currentState = ref.read(applicationsProvider);
      ApplicationModel? application;

      try {
        application = currentState.applications.firstWhere(
          (app) => app.id == applicationId || app.id.contains(applicationId),
        );
      } catch (_) {
        // Not found in list
      }

      // 2. If not found, then fetch it
      if (application == null) {
        application = await ref
            .read(applicationsProvider.notifier)
            .fetchSingleApplications(applicationId: applicationId);
      }

      if (!mounted) return;

      if (_selectedStatus != targetStatus) {
        setState(() {
          _selectedStatus = targetStatus;
        });
      }

      if (application == null) {
        debugPrint('❌ Application not found: $applicationId');
        return;
      }

      // 3. Check if the job is loaded properly (either as an object or if we need to fetch it)
      if (application.job == null) {
        debugPrint('❌ Application found but application.job is null');
        return;
      }

      debugPrint('✅ Application found: $applicationId');
      debugPrint('🚀 Opening JobBottomSheet');

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return JobBottomSheet(
            job: application!.job!,
            application: application,
            variant: JobCardVariant.application,
            changeTab: widget.changeTab,
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to open application notification: $e');
      debugPrint('$stackTrace');
    } finally {
      _openingNotificationApplication = false;
    }
  }

  @override
  void dispose() {
    NavigationService.unregisterApplicationDetailsHandler();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applicationsProvider);
    print("application meta ${state.meta?.counts?.applied}");
    return Scaffold(
      appBar: const CommonAppBar(title: "My Applications"),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DashboardNavLinks(
                icon: Icon(Icons.send_outlined, size: 24, color: Colors.white),
                onTap: () {
                  setState(() => _selectedStatus = "applied");
                  ref
                      .read(applicationsProvider.notifier)
                      .fetchApplications(status: "");
                },
                label: "Applied",
                count: state.meta?.counts?.applied ?? 0,
              ),
              DashboardNavLinks(
                icon: const Icon(
                  Icons.star_outline,
                  size: 24,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() => _selectedStatus = "shortlisted");
                  ref
                      .read(applicationsProvider.notifier)
                      .fetchApplications(status: "shortlisted");
                },
                label: "Shortlisted",
                count: state.meta?.counts?.shortlisted ?? 0,
              ),
              DashboardNavLinks(
                icon: const Icon(
                  Icons.person_add_alt_1_outlined,
                  size: 24,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() => _selectedStatus = "appointed");
                  ref
                      .read(applicationsProvider.notifier)
                      .fetchApplications(status: "appointed");
                },
                label: "Appointed",
                count: state.meta?.counts?.appointed ?? 0,
              ),
              DashboardNavLinks(
                icon: Icon(
                  Icons.check_circle_outline,
                  size: 24,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() => _selectedStatus = "confirmed");
                  ref
                      .read(applicationsProvider.notifier)
                      .fetchApplications(status: "confirmed");
                },
                label: "Confirmed",
                count: state.meta?.counts?.confirmed ?? 0,
              ),
              DashboardNavLinks(
                icon: Icon(
                  Icons.cancel_outlined,
                  size: 24,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() => _selectedStatus = "cancelled");
                  ref
                      .read(applicationsProvider.notifier)
                      .fetchApplications(status: "rejected");
                },
                label: "Cancelled",
                count: state.meta?.counts?.rejected ?? 0,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Text(
                  "${state.applications.length} ${_selectedStatus == "appointed"
                      ? "Appointed"
                      : _selectedStatus == "shortlisted"
                      ? "Shortlisted"
                      : _selectedStatus == "applied"
                      ? "Applied"
                      : _selectedStatus == "confirmed"
                      ? "Confirmed"
                      : _selectedStatus == "cancelled"
                      ? "Cancelled"
                      : "Rejected"}${state.applications.length == 1 ? " Application" : " Applications"}",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.neutrals02,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= BODY =================
   Widget _buildBody(state) {
    /// LOADING (Show skeleton whenever loading, not just when empty)
    if (state.isLoading) {
      return Center(
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (_, __) => const JobCardSkeleton(),
        ),
      );
    }

    /// ERROR
    if (state.error != null && state.applications.isEmpty) {
      return Center(child: Text(state.error ?? "Something went wrong"));
    }

    /// EMPTY
    if (!state.isLoading && state.applications.isEmpty) {
      return const Center(child: Text("No applications found"));
    }

    /// LIST
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(applicationsProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.applications.length + 1,
        itemBuilder: (context, index) {
          if (index == state.applications.length) {
            return _buildPaginationLoader(state);
          }

          final application = state.applications[index];

          return JobCard(
            job: application.job,
            application: application,
            variant: JobCardVariant.application,
            changeTab: widget.changeTab,
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
          itemCount: 6,
          itemBuilder: (_, __) => const JobCardSkeleton(),
        ),
      );
    }

    if (!state.hasMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text("No more applications")),
      );
    }

    return const SizedBox();
  }
}
