import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class AuthApi {

  Future<Response> login({
    required String email,
    required String password,
    required String role,
  }) async {

    return await DioClient.dio.post(
      "/auth/login",
      data: {
        "email": email,
        "password": password,
        "role": role,
      },
    );

  }

}