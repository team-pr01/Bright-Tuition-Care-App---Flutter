import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/promotion_api.dart';
import '../../data/promotion_repository.dart';
import '../notifier/promotion_notifier.dart';

/// ============================================================
/// API
/// ============================================================

final promotionApiProvider = Provider<PromotionApi>((ref) {
  return PromotionApi();
});

/// ============================================================
/// REPOSITORY
/// ============================================================

final promotionRepositoryProvider =
    Provider<PromotionRepository>((ref) {
  return PromotionRepository(
    ref.read(promotionApiProvider),
  );
});

/// ============================================================
/// NOTIFIER
/// ============================================================

final promotionProvider =
    StateNotifierProvider<
        PromotionNotifier,
        PromotionState>((ref) {
  return PromotionNotifier(
    ref.read(promotionRepositoryProvider),
  );
});