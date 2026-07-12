import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ApplicationState {
  applied,
  withdrawn,
}

class AppliedJobsNotifier
    extends StateNotifier<Map<String, ApplicationState>> {
  AppliedJobsNotifier() : super({});

  void apply(String jobId) {
    state = {
      ...state,
      jobId: ApplicationState.applied,
    };
  }

  void withdraw(String jobId) {
    state = {
      ...state,
      jobId: ApplicationState.withdrawn,
    };
  }
}

final appliedJobsProvider =
    StateNotifierProvider<
      AppliedJobsNotifier,
      Map<String, ApplicationState>
    >(
  (ref) => AppliedJobsNotifier(),
);