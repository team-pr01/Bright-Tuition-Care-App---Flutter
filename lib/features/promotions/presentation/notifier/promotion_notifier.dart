import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_error_handler.dart';
import '../../data/models/promotion_model.dart';
import '../../data/promotion_repository.dart';

class PromotionState {
  final bool isLoading;
  final List<PromotionModel> promotions;
  final String? error;

  const PromotionState({
    this.isLoading = false,
    this.promotions = const [],
    this.error,
  });

  PromotionState copyWith({
    bool? isLoading,
    List<PromotionModel>? promotions,
    String? error,
  }) {
    return PromotionState(
      isLoading: isLoading ?? this.isLoading,
      promotions: promotions ?? this.promotions,
      error: error,
    );
  }
}

class PromotionNotifier extends StateNotifier<PromotionState> {
  final PromotionRepository repository;

  PromotionNotifier(this.repository)
      : super(const PromotionState());

  Future<void> fetchPromotions() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final promotions =
          await repository.getPromotions();

      state = state.copyWith(
        isLoading: false,
        promotions: promotions,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ApiErrorHandler.getMessage(e),
      );
    }
  }

  Future<void> refresh() async {
    await fetchPromotions();
  }

  void clear() {
    state = const PromotionState();
  }
}