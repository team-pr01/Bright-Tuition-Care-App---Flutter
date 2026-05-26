import 'package:dio/dio.dart';

class PaymentApi {
  final Dio dio;

  PaymentApi(this.dio);

  /// ================= PAY =================
  Future<Response> pay(
    FormData data,
  ) async {
    return await dio.post(
      "/payment/pay",
      data: data,
    );
  }

  /// ================= GET ALL PAYMENTS =================
  Future<Response> getAllPayments({
    int page = 1,
    int limit = 10,
    String? status,
    String? keyword,
  }) async {
    return await dio.get(
      "/payment",
      queryParameters: {
        "page": page,
        "limit": limit,
        if (status != null) "status": status,
        if (keyword != null) "keyword": keyword,
      },
    );
  }

  /// ================= SINGLE PAYMENT =================
  Future<Response> getSinglePayment(
    String id,
  ) async {
    return await dio.get(
      "/payment/$id",
    );
  }

  /// ================= UPDATE STATUS =================
  Future<Response> updatePaymentStatus({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return await dio.patch(
      "/payment/update-status/$id",
      data: data,
    );
  }
}