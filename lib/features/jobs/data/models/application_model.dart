class ApplicationModel {
  final String? userId;
  final String? applicationId;

  ApplicationModel({
    this.userId,
    this.applicationId,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      userId: json['userId'],
      applicationId: json['applicationId'],
    );
  }
}