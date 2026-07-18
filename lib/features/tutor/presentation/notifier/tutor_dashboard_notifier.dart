import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:btcclient/features/tutor/data/tutor_repository.dart';
import 'package:btcclient/features/tutor/presentation/notifier/tutor_dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorDashboardNotifier
    extends StateNotifier<TutorDashboardState> {

  final TutorRepository repository;

  TutorDashboardNotifier(this.repository)
      : super(const TutorDashboardState());

  Future<void> fetchStats({bool refresh = false}) async {

    // Don't clear old data.
    state = state.copyWith(
      loading: state.data == null,
      refreshing: state.data != null,
      error: null,
    );

    try {
      final result = await repository.getStats();

      state = state.copyWith(
        loading: false,
        refreshing: false,
        data: result,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        refreshing: false,
        error: ApiErrorHandler.getMessage(e),
      );
    }
  }
}