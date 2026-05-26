import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';

import '../../data/payment_api.dart';
import '../../data/payment_repository.dart';

import '../notifier/payment_notifier.dart';

final paymentApiProvider =
    Provider<PaymentApi>((ref) {
  return PaymentApi(
    DioClient.dio,
  );
});

final paymentRepositoryProvider =
    Provider<PaymentRepository>((ref) {
  return PaymentRepository(
    ref.read(paymentApiProvider),
  );
});

final paymentProvider =
    StateNotifierProvider<
        PaymentNotifier,
        PaymentState>((ref) {
  return PaymentNotifier(
    ref.read(paymentRepositoryProvider),
  );
});