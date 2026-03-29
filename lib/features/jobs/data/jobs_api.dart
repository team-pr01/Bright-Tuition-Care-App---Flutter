import 'package:btcclient/core/network/dio_client.dart';

class JobsApi {
  Future<Map<String, dynamic>> getJobs(
      Map<String, dynamic> query) async {

    final response = await DioClient.dio.get(
      "/job",
      queryParameters: query,
    );

    print("JOBS API RAW: ${response.data}");

    return response.data;
  }
}