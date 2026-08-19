import 'package:btcclient/features/jobs/data/models/jobs_meta.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/jobs_api.dart';
import '../../data/jobs_repository.dart';
import '../../data/models/job_model.dart';
import '../../data/models/job_filter.dart';

/// ================= REPOSITORY PROVIDER =================
final jobsRepositoryProvider = Provider<JobsRepository>((ref) {
  return JobsRepository(JobsApi());
});

/// ================= STATE =================

class JobsState {
  final List<JobModel> jobs;

  final List<Map<String, dynamic>> jobsByCity;

  final int availableJobs;
  final int activeTutors;
  final int happyGuardians;
  final double averageRating;

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;

  final String? error;

  final JobFilter filter;
  final JobsMeta? meta;

  JobsState({
    required this.jobs,
    required this.jobsByCity,
    required this.availableJobs,
    required this.activeTutors,
    required this.happyGuardians,
    required this.averageRating,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.filter,
    this.error,
    this.meta,
  });

  factory JobsState.initial() {
    return JobsState(
      jobs: const [],
      jobsByCity: const [],

      availableJobs: 0,
      activeTutors: 0,
      happyGuardians: 0,
      averageRating: 0.0,

      isLoading: false,
      isLoadingMore: false,
      hasMore: true,

      filter: JobFilter(),
    );
  }

  JobsState copyWith({
    List<JobModel>? jobs,
    List<Map<String, dynamic>>? jobsByCity,

    int? availableJobs,
    int? activeTutors,
    int? happyGuardians,
    double? averageRating,

    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,

    String? error,
    JobFilter? filter,
    JobsMeta? meta,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      jobsByCity: jobsByCity ?? this.jobsByCity,

      availableJobs: availableJobs ?? this.availableJobs,

      activeTutors: activeTutors ?? this.activeTutors,

      happyGuardians: happyGuardians ?? this.happyGuardians,

      averageRating: averageRating ?? this.averageRating,

      isLoading: isLoading ?? this.isLoading,

      isLoadingMore: isLoadingMore ?? this.isLoadingMore,

      hasMore: hasMore ?? this.hasMore,

      error: error,
      filter: filter ?? this.filter,
      meta: meta ?? this.meta,
    );
  }
}

/// ================= NOTIFIER =================
class JobsNotifier extends StateNotifier<JobsState> {
  final JobsRepository repo;

  JobsNotifier(this.repo) : super(JobsState.initial()) {
    print("JOBS NOTIFIER CREATED");
  }

  /// ================= INITIAL FETCH =================
  Future<void> fetchJobs({JobFilter? newFilter}) async {
    // final token = await LocalStorage.getToken();

    // if (token == null) return;

    final filter = (newFilter ?? state.filter).copyWith(
      status: "live", // 🔥 FORCE ALWAYS
      skip: 0,
    );

    state = state.copyWith(
      isLoading: state.jobs.isEmpty,
      hasMore: true,
      error: null,
      filter: filter,
    );

    try {
      final res = await repo.getJobs(filter);

      state = state.copyWith(
        jobs: res.jobs,
        meta: res.meta,
        isLoading: false,
        hasMore: res.meta.hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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
      final nextFilter = state.filter.copyWith(skip: state.jobs.length);

      final res = await repo.getJobs(nextFilter);
      final newJobs = res.jobs;

      state = state.copyWith(
        jobs: [...state.jobs, ...newJobs],
        meta: res.meta,
        isLoadingMore: false,
        hasMore: res.meta.hasMore,
        filter: nextFilter,
      );

      print("✅ Loaded more: ${newJobs.length}");
    } catch (e) {
      print("❌ Load more error: $e");

      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  Future<void> fetchCounterStats() async {
    try {
      final data = await repo.getCounterStats();

      final availableJobs = _toInt(data['availableJobs']);

      final activeTutors = _toInt(data['activeTutors']);

      final happyGuardians = _toInt(data['happyGuardians']);

      final averageRating = _toDouble(data['averageRating']);

      final rawCities = data['jobsByCity'];

      final List<Map<String, dynamic>> cities = [];

      if (rawCities is List) {
        for (final item in rawCities) {
          if (item is Map) {
            final city = item['city']?.toString().trim() ?? '';

            final count = _toInt(item['count']);

            if (city.isNotEmpty) {
              cities.add({'city': city, 'count': count});
            }
          }
        }
      }

      print(
        '📊 COUNTER STATS: '
        'availableJobs=$availableJobs, '
        'activeTutors=$activeTutors, '
        'happyGuardians=$happyGuardians, '
        'averageRating=$averageRating',
      );

      print('🏙️ JOBS BY CITY: $cities');

      state = state.copyWith(
        availableJobs: availableJobs,
        activeTutors: activeTutors,
        happyGuardians: happyGuardians,
        averageRating: averageRating,
        jobsByCity: cities,
        error: null,
      );
    } catch (e) {
      print('❌ COUNTER STATS ERROR: $e');

      state = state.copyWith(error: e.toString());
    }
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

  double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  /// ================= APPLY FILTER =================
  Future<void> applyFilter(JobFilter filter) async {
    print("APPLY FILTER CALLED");

    await fetchJobs(newFilter: filter);
  }

  /// ================= REFRESH =================
  Future<void> refresh() async {
    try {
      final res = await repo.getJobs(state.filter);

      state = state.copyWith(
        jobs: res.jobs,
        meta: res.meta,
        hasMore: res.meta.hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<bool> applyJob({required String jobId, required String userId}) async {
    try {
      await repo.applyJob(jobId: jobId, userId: userId);

      return true;
    } catch (e) {
      if (e is DioException) {
        print("❌ STATUS: ${e.response?.statusCode}");
        print("❌ ERROR BODY: ${e.response?.data}");
      } else {
        print("❌ ERROR: $e");
      }
      return false;
    }
  }

  Future<bool> withdrawApplication({required String applicationId}) async {
    try {
      await repo.withdrawApplication(applicationId: applicationId);
      return true;
    } catch (e) {
      if (e is DioException) {
        print("❌ STATUS: ${e.response?.statusCode}");
        print("❌ ERROR: ${e.response?.data}");
      }
      return false;
    }
  }

  Future<JobModel> fetchJobByCustomId(String jobId) async {
    try {
      final job = await repo.getSingleJobByCustomJobId(jobId);

      return job;
    } catch (e) {
      print("❌ Failed to fetch notification job: $e");
      rethrow;
    }
  }
}
