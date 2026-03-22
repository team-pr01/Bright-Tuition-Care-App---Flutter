import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/requests/refund_application_request.dart';
import '../../data/results/refund_application_result.dart';
import '../../data/tutor_repository.dart';

class RefundNotifier extends StateNotifier<AsyncValue<RefundResponse?>> {
  final TutorRepository repository;

  RefundNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> applyRefund(RefundApplicationRequest request) async {
    state = const AsyncValue.loading();

    try {
      final response = await repository.applyRefund(request);

      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}