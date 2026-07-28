import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_nav_links.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/jobs/presentation/enums/job_card_variant.dart';
import 'package:btcclient/features/jobs/presentation/provider/application_provider.dart';
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

  late String _selectedStatus;
  @override
  void initState() {
    super.initState();

    _selectedStatus = widget.initialStatus ?? "applied";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(applicationsProvider.notifier)
          .fetchApplications(status: _selectedStatus);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(applicationsProvider.notifier).loadMore();
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
    final state = ref.watch(applicationsProvider);
    print("application meta ${state.meta?.counts?.applied}");
    return Scaffold(
      appBar: const CommonAppBar(),
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
                icon: SvgPicture.asset(
                  "assets/icons/navigations/applied.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                onTap: () {
                  ref
                      .read(applicationsProvider.notifier)
                      .fetchApplications(status: "applied");
                },
                label: "Applied",
                count: state.meta?.counts?.applied ?? 0,
              ),
              DashboardNavLinks(
                icon: SvgPicture.asset(
                  "assets/icons/navigations/shortlisted.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                onTap: () {
                  ref
                      .read(applicationsProvider.notifier)
                      .fetchApplications(status: "shortlisted");
                },
                label: "Shortlisted",
                count: state.meta?.counts?.shortlisted ?? 0,
              ),
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
                onTap: () {
                  ref
                      .read(applicationsProvider.notifier)
                      .fetchApplications(status: "appointed");
                },
                label: "Appointed",
                count: state.meta?.counts?.appointed ?? 0,
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
                onTap: () {
                  ref
                      .read(applicationsProvider.notifier)
                      .fetchApplications(status: "confirmed");
                },
                label: "Confirmed",
                count: state.meta?.counts?.confirmed ?? 0,
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
                onTap: () {
                  ref
                      .read(applicationsProvider.notifier)
                      .fetchApplications(status: "cancelled");
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
                  "${state.applications.length} ${_selectedStatus == "appointed" ? "Appointed" :_selectedStatus == "shortlisted" ? "Shortlisted":_selectedStatus == "applied" ? "Applied": _selectedStatus == "confirmed" ? "Confirmed": _selectedStatus == "cancelled" ? "Cancelled" : "Rejected"} Applications",
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
    /// LOADING
    if (state.isLoading && state.applications.isEmpty) {
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
