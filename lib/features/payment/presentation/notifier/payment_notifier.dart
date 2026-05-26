import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/payment_repository.dart';
import '../../data/requests/pay_request.dart';

class PaymentState {

  final bool isLoading;

  final String? error;

  PaymentState({
    this.isLoading = false,
    this.error,
  });

  PaymentState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return PaymentState(
      isLoading:
          isLoading ?? this.isLoading,

      error: error,
    );
  }
}

class PaymentNotifier
    extends StateNotifier<PaymentState> {

  final PaymentRepository repository;

  PaymentNotifier(this.repository)
      : super(PaymentState());

  Future<bool> pay(
    PayRequest request,
  ) async {

    try {

      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      await repository.pay(request);

      state = state.copyWith(
        isLoading: false,
      );

      return true;

    } catch (e) {

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );

      return false;
    }
  }
}