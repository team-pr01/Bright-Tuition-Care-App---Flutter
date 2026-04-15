class AppliedModel {
  final String? userId;
  final String? applicationId;

  AppliedModel({
    this.userId,
    this.applicationId,
  });

  factory AppliedModel.fromJson(Map<String, dynamic> json) {
    return AppliedModel(
      userId: json['userId'],
      applicationId: json['applicationId'],
    );
  }
}