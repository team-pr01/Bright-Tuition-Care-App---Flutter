class UpdateInvoiceRequest {
  final double amount;
  final String dueDate;

  UpdateInvoiceRequest({
    required this.amount,
    required this.dueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "dueDate": dueDate,
    };
  }
}