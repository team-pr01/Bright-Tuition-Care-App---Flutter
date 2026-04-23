import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class PostJobApi {
  Future<Response> postJob({required Map<String, dynamic> body}) async {
    return await DioClient.dio.post("/job/post", data: body);
  }

  Future<Response> updateJob({
    required String jobId,
    required Map<String, dynamic> body,
  }) async {
    return await DioClient.dio.patch("/job/update/$jobId", data: body);
  }
}
