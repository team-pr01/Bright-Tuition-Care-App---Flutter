class ForgotPasswordResult {
  final String message;

  ForgotPasswordResult({
    required this.message,
  });

  factory ForgotPasswordResult.fromJson(
    Map<String, dynamic> json,
  ) {
    return ForgotPasswordResult(
      message: json["message"] ?? "",
    );
  }
}