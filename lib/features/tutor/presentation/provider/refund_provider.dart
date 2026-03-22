import 'package:btcclient/features/tutor/data/results/refund_application_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/refund_notifier.dart';
import 'tutor_repository_provider.dart';

final refundProvider =
    StateNotifierProvider<RefundNotifier, AsyncValue<RefundResponse?>>((ref) {
  final repo = ref.watch(tutorRepositoryProvider);
  return RefundNotifier(repo);
});