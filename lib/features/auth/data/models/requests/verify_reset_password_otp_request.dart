class VerifyResetPasswordOtpRequest {

  final String phoneNumber;
  final String otp;

  VerifyResetPasswordOtpRequest({
    required this.phoneNumber,
    required this.otp,
  });

  Map<String, dynamic> toJson() {

    return {
      "phoneNumber": phoneNumber,
      "otp": otp,
    };

  }

}