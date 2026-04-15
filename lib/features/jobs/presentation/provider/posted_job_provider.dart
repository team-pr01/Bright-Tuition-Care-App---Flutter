
import 'package:btcclient/features/jobs/presentation/notifier/jobs_notifier.dart';
import 'package:btcclient/features/jobs/presentation/notifier/posted_jobs_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ================= REPOSITORY PROVIDER =================
final postedJobsProvider =
    StateNotifierProvider<PostedJobsNotifier, PostedJobsState>((ref) {
  final repo = ref.read(jobsRepositoryProvider);
  return PostedJobsNotifier(repo);
});