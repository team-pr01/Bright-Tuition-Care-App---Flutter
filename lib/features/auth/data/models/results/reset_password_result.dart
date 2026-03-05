class ResetPasswordResult {

  final String message;

  ResetPasswordResult({
    required this.message,
  });

  factory ResetPasswordResult.fromJson(
    Map<String, dynamic> json,
  ) {

    return ResetPasswordResult(
      message: json["message"] ?? "",
    );

  }

}