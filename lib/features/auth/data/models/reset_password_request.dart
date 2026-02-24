class ResetPasswordRequest {

  final String phoneNumber;
  final String newPassword;

  ResetPasswordRequest({
    required this.phoneNumber,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {

    return {
      "phoneNumber": phoneNumber,
      "newPassword": newPassword,
    };

  }

}