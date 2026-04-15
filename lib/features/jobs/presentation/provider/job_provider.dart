import 'package:btcclient/features/jobs/presentation/notifier/jobs_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ================= MAIN PROVIDER =================
final jobsProvider = StateNotifierProvider<JobsNotifier, JobsState>((ref) {
  final repo = ref.read(jobsRepositoryProvider);
  return JobsNotifier(repo);
});