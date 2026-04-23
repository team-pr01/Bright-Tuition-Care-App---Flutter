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

Future<Map<String, dynamic>> getMyApplications({
  required Map<String, dynamic> query,
}) async {
  final response = await DioClient.dio.get(
    "/tutor/my-applications",
    queryParameters: query,
  );

  print("📦 APPLICATIONS RAW: ${response.data}");

  return response.data;
}

Future<Map<String, dynamic>> getMyPostedJobs({
  required Map<String, dynamic> query,
}) async {
  final response = await DioClient.dio.get(
    "/job/my-posted-jobs",
    queryParameters: query,
  );

  print("📦 POSTED JOBS RAW: ${response.data}");

  return response.data;
}

Future<Map<String, dynamic>> fetchApplications({
  required String jobId,
  required int page,
  required int limit,
  String? status,
  String? keyword,
  String? demoDate,
}) async {
  final query = {
    "page": page,
    "limit": limit,
    if (status != null && status.isNotEmpty) "status": status,
    if (keyword != null && keyword.isNotEmpty) "keyword": keyword,
    if (demoDate != null && demoDate.isNotEmpty) "demoDate": demoDate,
  };

  final response = await DioClient.dio.get(
    "/application/job/$jobId",
    queryParameters: query,
  );

  print("📦 APPLICATIONS RAW: ${response.data}");

  return response.data;
}

}
