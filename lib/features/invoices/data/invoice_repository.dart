import 'package:btcclient/features/invoices/data/invoive_api.dart';
import 'package:btcclient/features/invoices/data/models/invoice_model.dart';
import 'package:btcclient/features/invoices/data/requests/update_invoice_request.dart';

class InvoiceRepository {
  final InvoiceApi api;

  InvoiceRepository(this.api);

  Future<List<InvoiceModel>> getMyInvoices() async {
  final response = await api.getMyInvoices();

  return (response.data["data"] as List)
      .map((e) => InvoiceModel.fromJson(e))
      .toList();
}

  Future<InvoiceModel> getSingleInvoice(String id) async {
    final response = await api.getSingleInvoiceById(id);

    return InvoiceModel.fromJson(response.data["data"]);
  }

  Future<void> updateInvoice({
    required String id,
    required UpdateInvoiceRequest request,
  }) async {
    await api.updateInvoice(id: id, data: request.toJson());
  }

  Future<void> deleteInvoice(String id) async {
    await api.deleteInvoice(id);
  }
}
