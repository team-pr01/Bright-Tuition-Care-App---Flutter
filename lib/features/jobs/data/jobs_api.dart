import 'package:btcclient/core/network/dio_client.dart';

class JobsApi {
  Future<Map<String, dynamic>> getJobs(Map<String, dynamic> query) async {
    final response = await DioClient.dio.get("/job", queryParameters: query);

    print("JOBS API RAW: ${response.data}");

    return response.data;
  }

  Future<Map<String, dynamic>> applyForJob({
    required String jobId,
    required String userId,
  }) async {
    final body = {"jobId": jobId, "userId": userId};

    print("🔥 APPLY API BODY: $body");

    final response = await DioClient.dio.post("/application/apply", data: body);

    print("✅ APPLY RESPONSE: ${response.data}");

    return response.data;
  }
  Future<Map<String, dynamic>> withdrawApplication({
  required String applicationId,
}) async {

  final response = await DioClient.dio.patch(
    "/application/withdraw/$applicationId",
  );

  print("🔥 WITHDRAW RESPONSE: ${response.data}");

  return response.data;
}
}
