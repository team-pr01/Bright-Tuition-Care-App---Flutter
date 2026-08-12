class RefundData {
  final String userId;
  final String tutorId;
  final String jobId;
  final String amount;
  final String paymentMethod;
  final String? bankName;
  final String accountNumber;
  final String refundReason;
  final String status;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  RefundData({
    required this.userId,
    required this.tutorId,
    required this.jobId,
    required this.amount,
    required this.paymentMethod,
    this.bankName,
    required this.accountNumber,
    required this.refundReason,
    required this.status,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RefundData.fromJson(Map<String, dynamic> json) {
    return RefundData(
      userId: json["userId"],
      tutorId: json["tutorId"],
      jobId: json["jobId"].trim(),
      amount: json["amount"].toString(),
      paymentMethod: json["paymentMethod"],
      bankName: json["bankName"],
      accountNumber: json["accountNumber"],
      refundReason: json["refundReason"],
      status: json["status"],
      id: json["_id"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }
}