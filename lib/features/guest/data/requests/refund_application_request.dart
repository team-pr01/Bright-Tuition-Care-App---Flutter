class RefundApplicationRequest {
  final String jobId;
  final double amount;
  final String paymentMethod;
  final String? bankName;
  final String accountNumber;
  final String refundReason;

  RefundApplicationRequest({
    required this.jobId,
    required this.amount,
    required this.paymentMethod,
    this.bankName,
    required this.accountNumber,
    required this.refundReason,
  });

  Map<String, dynamic> toJson() {
    return {
      "jobId": jobId.trim(),
      "amount": amount,
      "paymentMethod": paymentMethod,
      "bankName": paymentMethod == "Bank Transfer" ? bankName : null,
      "accountNumber": accountNumber,
      "refundReason": refundReason,
    };
  }
}