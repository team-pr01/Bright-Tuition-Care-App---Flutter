import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState {
  final int currentIndex;
  final String? jobStatusFilter;

  NavigationState({
    required this.currentIndex,
    this.jobStatusFilter,
  });

  NavigationState copyWith({
    int? currentIndex,
    String? jobStatusFilter,
  }) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      jobStatusFilter: jobStatusFilter,
    );
  }
}

final navigationProvider =
    StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier()
      : super(NavigationState(currentIndex: 0));

  void changeTab(int index, {String? jobStatus}) {
    state = state.copyWith(
      currentIndex: index,
      jobStatusFilter: jobStatus,
    );
  }
}