class ResendOtpResult {

  final String message;

  ResendOtpResult({
    required this.message,
  });

  factory ResendOtpResult.fromJson(
    Map<String, dynamic> json,
  ) {
    return ResendOtpResult(
      message: json["message"] ?? "",
    );
  }

}