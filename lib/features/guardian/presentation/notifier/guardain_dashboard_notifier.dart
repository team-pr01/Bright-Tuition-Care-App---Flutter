import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:btcclient/features/guardian/data/guardain_repository.dart';
import 'package:btcclient/features/guardian/presentation/notifier/guardian_dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuardianDashboardNotifier
    extends StateNotifier<GuardianDashboardState> {
  final GuardianRepository repository;

  GuardianDashboardNotifier(this.repository)
      : super(const GuardianDashboardState());

  Future<void> fetchStats({bool refresh = false}) async {
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