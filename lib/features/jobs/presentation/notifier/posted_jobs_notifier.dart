import 'package:btcclient/features/jobs/data/models/posted_job_meta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/jobs_repository.dart';
import '../../data/models/job_model.dart';

/// ================= STATE =================
class PostedJobsState {
  final List<JobModel> jobs;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final PostedJobMeta? meta;
  final String? selectedStatus;

  PostedJobsState({
    required this.jobs,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    this.error,
    this.meta,
    this.selectedStatus,
  });

  factory PostedJobsState.initial() {
    return PostedJobsState(
      jobs: [],
      isLoading: false,
      isLoadingMore: false,
      hasMore: true,
      meta: null,
      selectedStatus: null,
    );
  }

  PostedJobsState copyWith({
    List<JobModel>? jobs,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    PostedJobMeta? meta,
    String? selectedStatus,
  }) {
    return PostedJobsState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      meta: meta ?? this.meta,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }
}
/// ================= NOTIFIER =================
class PostedJobsNotifier extends StateNotifier<PostedJobsState> {
  final JobsRepository repo;

  PostedJobsNotifier(this.repo) : super(PostedJobsState.initial());

  int skip = 0;
  final int limit = 10;

  Future<void> fetchPostedJobs({String? status}) async {
    skip = 0;

    state = state.copyWith(
      isLoading: true,
      jobs: [],
      hasMore: true,
      error: null,
      selectedStatus: status,
    );

    try {
      final res = await repo.getMyPostedJobs(
        query: {
          "skip": skip,
          "limit": limit,
          if (status != null) "status": status,
        },
      );

      state = state.copyWith(
        jobs: res.jobs,
        meta: res.meta,
        isLoading: false,
        hasMore: res.meta.hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore({String? status}) async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      skip = state.jobs.length;

      final res = await repo.getMyPostedJobs(
        query: {
          "skip": skip,
          "limit": limit,
          if (status != null) "status": status,
        },
      );

      state = state.copyWith(
        jobs: [...state.jobs, ...res.jobs],
        meta: res.meta,
        isLoadingMore: false,
        hasMore: res.meta.hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh({String? status}) async {
    await fetchPostedJobs(status: status);
  }
}