import '../models/invoice_model.dart';

class InvoiceResponse {
  final bool success;
  final List<InvoiceModel> invoices;

  InvoiceResponse({
    required this.success,
    required this.invoices,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceResponse(
      success: json["success"] ?? false,
      invoices: (json["data"] as List)
          .map((e) => InvoiceModel.fromJson(e))
          .toList(),
    );
  }
}