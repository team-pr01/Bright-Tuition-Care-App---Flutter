class VerifyOtpResult {

  final bool success;
  final String message;

  VerifyOtpResult({
    required this.success,
    required this.message,
  });

  factory VerifyOtpResult.fromJson(Map<String, dynamic> json) {

    return VerifyOtpResult(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );

  }

}