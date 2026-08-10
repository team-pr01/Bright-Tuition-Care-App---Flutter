import 'package:btcclient/features/notifications/data/notification_api.dart';
import 'package:btcclient/features/notifications/data/notification_model.dart';
import 'package:btcclient/features/notifications/data/notification_repository.dart';
import 'package:btcclient/features/notifications/services/notification_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btcclient/core/utils/notification_service.dart';
import 'notification_state.dart';

final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  return NotificationRepository(
    NotificationApi(),
  );
});

final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
  (ref) => NotificationNotifier(
    ref.read(notificationRepositoryProvider),
  ),
);

class NotificationNotifier
    extends StateNotifier<NotificationState> {

  final NotificationRepository _repository;

 NotificationNotifier(this._repository)
    : super(const NotificationState()) {
  NotificationService().onNotificationReceived = () {
    debugPrint(
      '🔄 FCM received → refreshing notification list',
    );

    loadNotifications();
  };
}

  Future<void> loadNotifications() async {
    try {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
      );

      final notifications =
          await _repository.getMyNotifications();

      state = state.copyWith(
        notifications: notifications,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadNotifications();
  }

  Future<void> markAsRead(String id) async {
    try {
      await _repository.markAsRead(id);

      final updated =
          state.notifications.map((notification) {
        if (notification.id == id) {
          return notification.copyWith(
            isRead: true,
          );
        }

        return notification;
      }).toList();

      state = state.copyWith(
        notifications: updated,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  // ============================================================
  // NOTIFICATION TAP
  // ============================================================

  Future<void> onNotificationTap(
    NotificationModel notification,
  ) async {
    debugPrint(
      '🔔 Notification tapped',
    );

    debugPrint(
      '🔔 ID: ${notification.id}',
    );

    debugPrint(
      '🔔 TYPE: ${notification.type}',
    );

    debugPrint(
      '🔔 DATA: ${notification.data}',
    );

    // ----------------------------------------------------------
    // Mark as read
    // ----------------------------------------------------------

    if (!notification.isRead) {
      await markAsRead(notification.id);
    }

    // ----------------------------------------------------------
    // Route notification
    // ----------------------------------------------------------

    NotificationRouter.handleNotification(
      notification.data,
    );
  }
}