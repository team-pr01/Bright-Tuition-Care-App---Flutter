class SignupResult {

  final String email;
  final String userId;
  final bool isOtpVerified;

  const SignupResult({
    required this.email,
    required this.userId,
    required this.isOtpVerified,
  });

  factory SignupResult.fromJson(Map<String, dynamic> json) {

    return SignupResult(
      email: json["email"],
      userId: json["userId"],
      isOtpVerified: json["isOtpVerified"] ?? false,
    );

  }

}