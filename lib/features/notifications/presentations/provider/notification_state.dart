

import 'package:btcclient/features/notifications/data/notification_model.dart';

class NotificationState {
  final bool isLoading;
  final List<NotificationModel> notifications;
  final String? error;

  const NotificationState({
    this.isLoading = false,
    this.notifications = const [],
    this.error,
  });

  /// Number of unread notifications
  int get unreadCount =>
      notifications.where((e) => !e.isRead).length;

  /// Whether notification list is empty
  bool get isEmpty => notifications.isEmpty;

  NotificationState copyWith({
    bool? isLoading,
    List<NotificationModel>? notifications,
    String? error,
    bool clearError = false,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  String toString() {
    return '''
NotificationState(
  isLoading: $isLoading,
  notifications: ${notifications.length},
  unreadCount: $unreadCount,
  error: $error,
)
''';
  }
}