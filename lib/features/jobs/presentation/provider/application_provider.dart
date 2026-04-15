import 'package:btcclient/features/jobs/presentation/notifier/applicatoin_notifier.dart';
import 'package:btcclient/features/jobs/presentation/notifier/jobs_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationsProvider =
    StateNotifierProvider<ApplicationsNotifier, ApplicationsState>((ref) {
      final repo = ref.read(jobsRepositoryProvider);
      return ApplicationsNotifier(repo);
    });
