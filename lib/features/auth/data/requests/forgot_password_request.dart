class ForgetPasswordRequest {

  final String phoneNumber;

  ForgetPasswordRequest({
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {

    return {
      "phoneNumber": phoneNumber,
    };

  }

}