class InvoiceModel {
  final String id;
  final String invoiceId;
  final String invoiceType;
  final String status;
  final double amount;
  final String? dueDate;
  final String? paidDate;
  final String? createdDate;
  final String? jobId;

  InvoiceModel({
    required this.id,
    required this.invoiceId,
    required this.invoiceType,
    required this.status,
    required this.amount,
    this.dueDate,
    this.createdDate,
    this.paidDate,
    this.jobId,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json["_id"] ?? "",
      invoiceId: json["invoiceId"] ?? "",
      invoiceType: json["invoiceType"] ?? "",
      status: json["status"] ?? "",
      amount: (json["amount"] ?? 0).toDouble(),
      dueDate: json["dueDate"],
      paidDate: json["paidDate"],
      createdDate: json["createdAt"],
      jobId: json["jobId"]?["jobId"],
    );
  }
}