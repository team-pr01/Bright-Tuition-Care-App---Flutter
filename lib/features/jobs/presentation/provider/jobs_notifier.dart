import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/jobs_api.dart';
import '../../data/jobs_repository.dart';
import '../../data/models/job_model.dart';
import '../../data/models/job_filter.dart';
import '../../../../core/storage/local_storage.dart';

/// ================= REPOSITORY PROVIDER =================
final jobsRepositoryProvider =
    Provider<JobsRepository>((ref) {
  return JobsRepository(JobsApi());
});

/// ================= STATE =================
class JobsState {
  final List<JobModel> jobs;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final JobFilter filter;

  JobsState({
    required this.jobs,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.filter,
    this.error,
  });

  factory JobsState.initial() {
    return JobsState(
      jobs: [],
      isLoading: false,
      isLoadingMore: false,
      hasMore: true,
      filter: JobFilter(),
    );
  }

  JobsState copyWith({
    List<JobModel>? jobs,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    JobFilter? filter,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      filter: filter ?? this.filter,
    );
  }
}

/// ================= MAIN PROVIDER =================
final jobsProvider =
    StateNotifierProvider<JobsNotifier, JobsState>((ref) {
  final repo = ref.read(jobsRepositoryProvider);
  return JobsNotifier(repo);
});

/// ================= NOTIFIER =================
class JobsNotifier extends StateNotifier<JobsState> {
  final JobsRepository repo;

  JobsNotifier(this.repo) : super(JobsState.initial()) {
    print("JOBS NOTIFIER CREATED");
  }

  /// ================= INITIAL FETCH =================
  Future<void> fetchJobs({JobFilter? newFilter}) async {
    print("FETCH JOBS CALLED");

    final token = await LocalStorage.getToken();

    /// 🔥 IMPORTANT (fix your previous bug)
    if (token == null) {
      print("❌ Token not available — skipping API call");
      return;
    }

    final filter = newFilter ?? state.filter;

    state = state.copyWith(
      isLoading: true,
      jobs: [],
      hasMore: true,
      error: null,
      filter: filter.copyWith(skip: 0),
    );

    try {
      final jobs = await repo.getJobs(state.filter);

      state = state.copyWith(
        jobs: jobs,
        isLoading: false,
        hasMore: jobs.length == state.filter.limit,
      );

      print("✅ Jobs fetched: ${jobs.length}");
    } catch (e) {
      print("❌ Fetch error: $e");

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// ================= LOAD MORE =================
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) {
      return;
    }

    print("LOAD MORE CALLED");

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextFilter =
          state.filter.copyWith(skip: state.jobs.length);

      final newJobs = await repo.getJobs(nextFilter);

      state = state.copyWith(
        jobs: [...state.jobs, ...newJobs],
        isLoadingMore: false,
        hasMore: newJobs.length == state.filter.limit,
        filter: nextFilter,
      );

      print("✅ Loaded more: ${newJobs.length}");
    } catch (e) {
      print("❌ Load more error: $e");

      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// ================= APPLY FILTER =================
  Future<void> applyFilter(JobFilter filter) async {
    print("APPLY FILTER CALLED");

    await fetchJobs(newFilter: filter);
  }

  /// ================= REFRESH =================
  Future<void> refresh() async {
    print("REFRESH CALLED");

    await fetchJobs(newFilter: state.filter);
  }
}