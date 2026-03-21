class Application {
  final String userId;
  final String applicationId;

  Application({
    required this.userId,
    required this.applicationId,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      userId: json['userId'] ?? "",
      applicationId: json['applicationId'] ?? "",
    );
  }
}