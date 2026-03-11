class NoticeModel {
  final String title;
  final String message;

  NoticeModel({
    required this.title,
    required this.message,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      title: json['title'] ?? '',
      message: json['description'] ?? '',
    );
  }
}