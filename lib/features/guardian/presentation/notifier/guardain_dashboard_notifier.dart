import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/guardain_repository.dart';

class GuardianDashboardNotifier
    extends StateNotifier<Map<String, dynamic>?> {

  final GuardianRepository repository;

  GuardianDashboardNotifier(this.repository) : super(null) {
    print("NOTIFIER CREATED");
  }

  Future<void> fetchStats() async {

    print("FETCH STATS CALLED");

    try {

      final result = await repository.getStats();

      print("API DATA: $result");

      state = result;

    } catch (e) {

      print("API ERROR: $e");

    }
  }
}