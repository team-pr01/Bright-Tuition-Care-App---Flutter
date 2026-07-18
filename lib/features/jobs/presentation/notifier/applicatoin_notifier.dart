import 'package:btcclient/features/jobs/data/models/application_meta.dart';
import 'package:btcclient/features/jobs/data/models/application_modal.dart';
import 'package:btcclient/features/jobs/presentation/notifier/jobs_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/local_storage.dart';
import '../../data/jobs_repository.dart';

/// ================= STATE =================
class ApplicationsState {
  final List<ApplicationModel> applications;
  final bool isLoading;
  final bool refreshing;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final ApplicationMeta? meta;

  ApplicationsState({
    required this.applications,
    required this.isLoading,
    required this.refreshing,
    required this.isLoadingMore,
    required this.hasMore,
    this.error,
    this.meta,
  });

  factory ApplicationsState.initial() {
    return ApplicationsState(
      applications: [],
      isLoading: false,
      refreshing: false,
      isLoadingMore: false,
      hasMore: true,
      meta: null, // ✅ ADD THIS
    );
  }

  ApplicationsState copyWith({
    List<ApplicationModel>? applications,
    bool? isLoading,
    bool? refreshing,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    ApplicationMeta? meta,
  }) {
    return ApplicationsState(
      applications: applications ?? this.applications,
      isLoading: isLoading ?? this.isLoading,
     refreshing: refreshing ?? this.refreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      meta: meta ?? this.meta,
    );
  }
}

/// ================= NOTIFIER =================
class ApplicationsNotifier extends StateNotifier<ApplicationsState> {
  final JobsRepository repo;

  ApplicationsNotifier(this.repo) : super(ApplicationsState.initial());

  int skip = 0;
  final int limit = 20;

  /// ================= INITIAL FETCH =================
  Future<void> fetchApplications({String? status}) async {
    final token = await LocalStorage.getToken();
    if (token == null) return;

    skip = 0;
    final firstLoad = state.applications.isEmpty;
    state = state.copyWith(
      isLoading: firstLoad,
      refreshing: !firstLoad,
      hasMore: true,
      error: null,
    );

    try {
      final res = await repo.getMyApplications(
        query: {
          "skip": skip,
          "limit": limit,
          if (status != null) "status": status,
        },
      );

      state = state.copyWith(
        applications: res.applications,
        meta: res.meta, // 🔥 THIS WAS MISSING
        isLoading: false,
        refreshing: false,
        hasMore: res.meta.hasMore,
        
      );
    } catch (e) {
      state = state.copyWith(isLoading: false,refreshing: false, error: e.toString());
    }
  }

  /// ================= LOAD MORE =================
  Future<void> loadMore({String? status}) async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      skip += limit;

      final res = await repo.getMyApplications(
        query: {
          "skip": skip,
          "limit": limit,
          if (status != null) "status": status,
        },
      );

      state = state.copyWith(
        applications: [...state.applications, ...res.applications],
        meta: res.meta, // 🔥 ADD THIS
        isLoadingMore: false,
        hasMore: res.meta.hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  /// ================= REFRESH =================
  Future<void> refresh({String? status}) async {
    await fetchApplications(status: status);
  }
}
