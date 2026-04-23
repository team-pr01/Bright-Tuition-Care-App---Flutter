import 'package:btcclient/features/jobs/presentation/notifier/job_application_notifier.dart';
import 'package:btcclient/features/jobs/presentation/notifier/jobs_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final jobApplicationProvider =
StateNotifierProvider<JobApplicationNotifier, JobApplicationState>((ref) {
  final repo = ref.watch(jobsRepositoryProvider);
  return JobApplicationNotifier(repo);
});