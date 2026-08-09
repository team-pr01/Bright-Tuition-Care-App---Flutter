import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:btcclient/core/network/api_exception.dart';
import 'package:btcclient/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class NotificationApi {
  /// Get logged-in user's notifications
  Future getMyNotifications() async {
    try {
      return await DioClient.dio.get(
        "/notification/my",
      );
    } on DioException catch (e) {
      throw ApiException(ApiErrorHandler.getMessage(e));
    } catch (e) {
      throw ApiException(ApiErrorHandler.getMessage(e));
    }
  }

  /// Mark notification as read
  Future markAsRead(String notificationId) async {
    try {
      return await DioClient.dio.patch(
        "/notification/read/$notificationId",
      );
    } on DioException catch (e) {
      throw ApiException(ApiErrorHandler.getMessage(e));
    } catch (e) {
      throw ApiException(ApiErrorHandler.getMessage(e));
    }
  }

  /// Admin API (optional)
  Future getAllNotifications() async {
    try {
      return await DioClient.dio.get(
        "/notification",
      );
    } on DioException catch (e) {
      throw ApiException(ApiErrorHandler.getMessage(e));
    } catch (e) {
      throw ApiException(ApiErrorHandler.getMessage(e));
    }
  }

  /// Admin API (optional)
  Future sendNotification(Map<String, dynamic> body) async {
    try {
      return await DioClient.dio.post(
        "/notification/send",
        data: body,
      );
    } on DioException catch (e) {
      throw ApiException(ApiErrorHandler.getMessage(e));
    } catch (e) {
      throw ApiException(ApiErrorHandler.getMessage(e));
    }
  }
}