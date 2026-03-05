class ResendForgotPasswordOtpResult {

  final String message;

  ResendForgotPasswordOtpResult({
    required this.message,
  });

  factory ResendForgotPasswordOtpResult.fromJson(
    Map<String, dynamic> json,
  ) {

    return ResendForgotPasswordOtpResult(
      message: json["message"] ?? "",
    );

  }

}