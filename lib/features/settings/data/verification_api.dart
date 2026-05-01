import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class VerificationApi {

  /// 🔥 SEND REQUEST
  Future<Response> sendRequest() async {
    return await DioClient.dio.post(
      "/profile-verification/send-request",
    );
  }

  /// 🔥 GET MY REQUEST
  Future<Response> getMyRequest() async {
    return await DioClient.dio.get(
      "/profile-verification/my-request",
    );
  }
}