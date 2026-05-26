class SubmitAddressCodeRequest {

  final String addressVerificationCode;

  SubmitAddressCodeRequest({
    required this.addressVerificationCode,
  });

  Map<String, dynamic> toJson() {

    return {
      "addressVerificationCode":
          addressVerificationCode,
    };
  }
}