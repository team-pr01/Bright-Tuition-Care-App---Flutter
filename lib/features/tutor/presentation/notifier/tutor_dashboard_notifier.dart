import 'package:btcclient/features/tutor/data/tutor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorDashboardNotifier
    extends StateNotifier<Map<String, dynamic>?> {

  final TutorRepository repository;

  bool isLoading = false;

  TutorDashboardNotifier(this.repository) : super(null);

  Future<void> fetchStats() async {
    try {
      isLoading = true;

      final result = await repository.getStats();

      state = result;

    } catch (e) {
      print("API ERROR: $e");
    } finally {
      isLoading = false;
    }
  }
}