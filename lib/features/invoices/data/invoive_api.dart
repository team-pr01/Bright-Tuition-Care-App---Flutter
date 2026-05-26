import 'package:dio/dio.dart';

class InvoiceApi {
  final Dio dio;

  InvoiceApi(this.dio);

  /// ================= GET JOB DETAILS FOR INVOICE =================
  Future<Response> getJobDetailsForInvoice(String id) async {
    return await dio.get(
      "/invoice/details/$id",
    );
  }

  /// ================= GET ALL INVOICES =================
  Future<Response> getAllInvoices({
    String? status,
    String? dueDate,
  }) async {
    return await dio.get(
      "/invoice",
      queryParameters: {
        if (status != null) "status": status,
        if (dueDate != null) "dueDate": dueDate,
      },
    );
  }

  /// ================= GET SINGLE INVOICE =================
  Future<Response> getSingleInvoiceById(String id) async {
    return await dio.get(
      "/invoice/$id",
    );
  }

  /// ================= GET MY INVOICES =================
  Future<Response> getMyInvoices() async {
    return await dio.get(
      "/invoice/my",
    );
  }

  /// ================= SEND INVOICE =================
  Future<Response> sendInvoice({
    required Map<String, dynamic> data,
  }) async {
    return await dio.post(
      "/invoice/send",
      data: data,
    );
  }

  /// ================= UPDATE INVOICE =================
  Future<Response> updateInvoice({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return await dio.put(
      "/invoice/update/$id",
      data: data,
    );
  }

  /// ================= DELETE INVOICE =================
  Future<Response> deleteInvoice(String id) async {
    return await dio.delete(
      "/invoice/delete/$id",
    );
  }
}