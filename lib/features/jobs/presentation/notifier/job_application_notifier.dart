import 'package:btcclient/features/jobs/data/jobs_repository.dart';
import 'package:btcclient/features/jobs/data/models/job_application_meta.dart';
import 'package:btcclient/features/jobs/data/models/job_application_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 class JobApplicationState {
  final List<JobApplicationModel> applications;
  final JobApplicationMeta? meta;

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;

  final String? error;

  JobApplicationState({
    required this.applications,
    required this.meta,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    this.error,
  });

  factory JobApplicationState.initial() {
    return JobApplicationState(
      applications: [],
      meta: null,
      isLoading: false,
      isLoadingMore: false,
      hasMore: true,
      error: null,
    );
  }

  JobApplicationState copyWith({
    List<JobApplicationModel>? applications,
    JobApplicationMeta? meta,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
  }) {
    return JobApplicationState(
      applications: applications ?? this.applications,
      meta: meta ?? this.meta,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}
class JobApplicationNotifier extends StateNotifier<JobApplicationState> {
  final JobsRepository repository;

  JobApplicationNotifier(this.repository)
      : super(JobApplicationState.initial());

  int page = 1;
  int limit = 10;

  String? status;
  String? keyword;
  String? demoDate;

  Future<void> fetchInitial(String jobId) async {
    page = 1;

    state = state.copyWith(
      isLoading: true,
      applications: [],
      hasMore: true,
      error: null,
    );

    await _fetch(jobId);
  }

  Future<void> loadMore(String jobId) async {
    if (state.isLoadingMore || !state.hasMore) return;

    page++;

    state = state.copyWith(isLoadingMore: true);

    await _fetch(jobId);
  }

 Future<void> applyFilters({
  required String jobId,
  String? newStatus,
  String? newKeyword,
  String? newDate,
  int? newLimit,
}) async {
  status = newStatus;
  keyword = newKeyword;
  demoDate = newDate;

  if (newLimit != null) {
    limit = newLimit; // ✅ FIX (limit must NOT be final)
  }

  page = 1; // reset page

  await fetchInitial(jobId);
}

/// 🔥 ADD THIS (for proper prev/next)
Future<void> goToPage(String jobId, int newPage) async {
  if (newPage < 1) return;

  page = newPage;

  await _fetch(jobId);
}  Future<void> _fetch(String jobId) async {
    try {
      final (list, metaData) = await repository.getApplications(
        jobId: jobId,
        page: page,
        limit: limit,
        status: status,
        keyword: keyword,
        demoDate: demoDate,
      );

      final updatedList = page == 1
          ? list
          : [...state.applications, ...list];

      state = state.copyWith(
        applications: updatedList,
        meta: metaData,
        isLoading: false,
        isLoadingMore: false,
        hasMore: metaData.page < metaData.totalPages,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }
} 