import 'package:btcclient/core/network/api_exception.dart';
import 'package:btcclient/features/notifications/data/notification_api.dart';
import 'package:btcclient/features/notifications/data/notification_model.dart';

class NotificationRepository {
  final NotificationApi api;

  NotificationRepository(this.api);

  /// Get logged-in user's notifications
  Future<List<NotificationModel>> getMyNotifications() async {
    final response = await api.getMyNotifications();

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(responseData["message"]);
    }

    final List list = responseData["data"] ?? [];

    return list
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }

  /// Mark one notification as read
  Future<void> markAsRead(String id) async {
    final response = await api.markAsRead(id);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(responseData["message"]);
    }
  }

  /// Send notification (Admin)
  Future<void> sendNotification(
      Map<String, dynamic> body,
      ) async {
    final response = await api.sendNotification(body);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(responseData["message"]);
    }
  }
}