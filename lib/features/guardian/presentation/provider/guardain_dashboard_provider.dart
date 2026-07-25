import 'package:btcclient/features/guardian/presentation/notifier/guardain_dashboard_notifier.dart';
import 'package:btcclient/features/guardian/presentation/notifier/guardian_dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'guardain_repository_provider.dart';

final guardianDashboardProvider =
    StateNotifierProvider<
        GuardianDashboardNotifier,
        GuardianDashboardState>((ref) {
  final repo = ref.watch(guardianRepositoryProvider);

  return GuardianDashboardNotifier(repo);
});