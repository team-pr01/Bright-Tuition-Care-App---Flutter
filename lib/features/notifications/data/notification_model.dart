class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final Map<String, dynamic> data;
  final bool isRead;
  final String deliveryStatus;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.data,
    required this.isRead,
    required this.deliveryStatus,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final notificationData =
        Map<String, dynamic>.from(json['data'] ?? {});

    return NotificationModel(
      id: json['_id']?.toString() ??
          json['id']?.toString() ??
          '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: notificationData['type']?.toString() ?? '',
      data: notificationData,
      isRead: json['isRead'] ?? false,
      deliveryStatus:
          json['deliveryStatus']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'message': message,
      'data': data,
      'isRead': isRead,
      'deliveryStatus': deliveryStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    Map<String, dynamic>? data,
    bool? isRead,
    String? deliveryStatus,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'NotificationModel('
        'id: $id, '
        'title: $title, '
        'type: $type, '
        'isRead: $isRead'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NotificationModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}