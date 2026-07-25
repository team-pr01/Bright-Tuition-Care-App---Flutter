import 'package:flutter/foundation.dart';

@immutable
class GuardianDashboardState {
  final bool loading;
  final bool refreshing;
  final Map<String, dynamic>? data;
  final String? error;

  const GuardianDashboardState({
    this.loading = true,
    this.refreshing = false,
    this.data,
    this.error,
  });

  GuardianDashboardState copyWith({
    bool? loading,
    bool? refreshing,
    Map<String, dynamic>? data,
    String? error,
  }) {
    return GuardianDashboardState(
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      data: data ?? this.data,
      error: error,
    );
  }
}