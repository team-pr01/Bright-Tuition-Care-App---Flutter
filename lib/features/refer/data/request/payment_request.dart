class UpdatePaymentRequest {
  final String paymentMethod;
  final String paymentAccountNumber;

  UpdatePaymentRequest({
    required this.paymentMethod,
    required this.paymentAccountNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "paymentMethod": paymentMethod,
      "paymentAccountNumber": paymentAccountNumber,
    };
  }
}