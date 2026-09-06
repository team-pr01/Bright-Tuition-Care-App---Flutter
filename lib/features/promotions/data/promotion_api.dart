import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:btcclient/core/network/api_exception.dart';
import 'package:btcclient/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class PromotionApi {
  Future<Response> getPromotions() async {
    try {
      return await DioClient.dio.get(
        "/app-promotion",
      );
    } on DioException catch (e) {
      throw ApiException(
        ApiErrorHandler.getMessage(e),
      );
    } catch (e) {
      throw ApiException(
        ApiErrorHandler.getMessage(e),
      );
    }
  }
}