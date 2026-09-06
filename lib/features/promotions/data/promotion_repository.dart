import 'package:btcclient/core/network/api_exception.dart';
import 'package:btcclient/features/promotions/data/models/promotion_model.dart';
import 'package:btcclient/features/promotions/data/promotion_api.dart';

class PromotionRepository {
  final PromotionApi api;

  PromotionRepository(this.api);

  Future<List<PromotionModel>> getPromotions() async {
    final response = await api.getPromotions();

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw ApiException(
        "Invalid promotion response.",
      );
    }

    if (responseData["success"] != true) {
      throw ApiException(
        responseData["message"]?.toString() ??
            "Failed to fetch promotions.",
      );
    }

    final List<dynamic> data =
        responseData["data"] as List<dynamic>? ?? [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(
          (json) => PromotionModel.fromJson(json),
        )
        .where(
          (promotion) => promotion.imageUrl.isNotEmpty,
        )
        .toList();
  }
}