import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/get_cout.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/search_bar/search_bar.dart';
import 'package:btcclient/features/jobs/presentation/provider/jobs_notifier.dart';
import 'package:btcclient/features/jobs/presentation/widgets/filter_form.dart';
import 'package:btcclient/features/jobs/presentation/widgets/job_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApplicationPage extends ConsumerStatefulWidget {

  const MyApplicationPage({super.key,});

  @override
  ConsumerState<MyApplicationPage> createState() => _MyApplicationPageState();
}

class _MyApplicationPageState extends ConsumerState<MyApplicationPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobsProvider.notifier).fetchJobs();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(jobsProvider.notifier).loadMore();
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
    final state = ref.watch(jobsProvider);
    print ("state.jobs: ${state.jobs}");

    /// 🔥 DEBUG (remove later)
    debugPrint("Jobs: ${state.jobs.length}");
    debugPrint("Loading: ${state.isLoading}");
    debugPrint("Error: ${state.error}");

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
                ref.read(jobsProvider.notifier).applyFilter(filter);
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
          /// 🔍 SEARCH BAR
          ReusableSearchBar(
            controller: _searchController,
            onChanged: (value) {
              /// 🔥 Connect to provider later
              debugPrint("Search: $value");
            },
          ),

          const SizedBox(height: 16),

          /// 📊 COUNT + FILTER
          Row(
            children: [
              Expanded(
                child: Text(
                  getCountText(state.jobs),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.neutrals02,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),

              AppButton(
                label: "Filter",
                onPressed: () {
                  openFilter(context);
                },
                variant: AppButtonVariant.outline,
                height: 32,
                width: 130,
                icon: Icons.tune,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= BODY =================
  Widget _buildBody(state) {
    /// LOADING FIRST TIME
    if (state.isLoading && state.jobs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    /// ERROR
    if (state.error != null && state.jobs.isEmpty) {
      return Center(child: Text(state.error ?? "Something went wrong"));
    }

    /// EMPTY
    if (!state.isLoading && state.jobs.isEmpty) {
      return const Center(child: Text("No jobs found"));
    }

    /// LIST
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(jobsProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.jobs.length + 1,
        itemBuilder: (context, index) {
          /// 🔥 Pagination Loader
          if (index == state.jobs.length) {
            return _buildPaginationLoader(state);
          }

          final job = state.jobs[index];

          return JobCard(
            job: job,
            variant: "application",
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
