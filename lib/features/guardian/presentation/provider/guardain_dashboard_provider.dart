import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/guardain_dashboard_notifier.dart';
import 'guardain_repository_provider.dart';

final 
guardianDashboardProvider =
StateNotifierProvider<GuardianDashboardNotifier, Map<String, dynamic>?>(

(ref) {

  final repo = ref.watch(guardianRepositoryProvider);

  return GuardianDashboardNotifier(repo);

});