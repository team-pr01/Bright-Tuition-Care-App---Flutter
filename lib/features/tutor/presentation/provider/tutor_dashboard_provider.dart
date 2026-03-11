import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/tutor_dashboard_notifier.dart';
import 'tutor_repository_provider.dart';

final tutorDashboardProvider =
StateNotifierProvider<TutorDashboardNotifier, Map<String, dynamic>?>(

(ref) {

  final repo = ref.watch(tutorRepositoryProvider);

  return TutorDashboardNotifier(repo);

});