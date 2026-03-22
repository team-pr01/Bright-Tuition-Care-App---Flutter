import 'package:btcclient/core/network/dio_client.dart';
import 'package:btcclient/features/tutor/data/requests/refund_application_request.dart';
import 'package:btcclient/features/tutor/data/results/refund_application_result.dart';

class TutorApi {

  Future<Map<String, dynamic>> getStats() async {

    final response = await DioClient.dio.get(
      "/tutor/stats",
    );

    print("RAW API RESPONSE: ${response.data}");

    return response.data;
  }
  Future<RefundResponse> applyRefund(RefundApplicationRequest request) async {
  final response = await DioClient.dio.post(
    "/refund-request/request-to-refund",
    data: request.toJson(),
  );

  return RefundResponse.fromJson(response.data); // ✅ FIX
}

}