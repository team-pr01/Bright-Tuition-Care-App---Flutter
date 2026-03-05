class VerifyResetPasswordOtpResult {

  final String message;

  VerifyResetPasswordOtpResult({
    required this.message,
  });

  factory VerifyResetPasswordOtpResult.fromJson(
    Map<String, dynamic> json,
  ) {

    return VerifyResetPasswordOtpResult(
      message: json["message"] ?? "",
    );

  }

}