class ResendForgotPasswordOtpRequest {

  final String phoneNumber;

  ResendForgotPasswordOtpRequest({
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {

    return {
      "phoneNumber": phoneNumber,
    };

  }

}