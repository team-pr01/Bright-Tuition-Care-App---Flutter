import 'package:flutter/foundation.dart';

@immutable
class TutorDashboardState {
  final bool loading;
  final bool refreshing;
  final Map<String, dynamic>? data;
  final String? error;

  const TutorDashboardState({
    this.loading = true,
    this.refreshing = false,
    this.data,
    this.error,
  });

  TutorDashboardState copyWith({
    bool? loading,
    bool? refreshing,
    Map<String, dynamic>? data,
    String? error,
  }) {
    return TutorDashboardState(
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      data: data ?? this.data,
      error: error,
    );
  }
}