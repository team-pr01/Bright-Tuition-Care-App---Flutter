import 'package:btcclient/features/auth/data/models/signup_request.dart';
import 'package:btcclient/features/auth/data/models/forgot_password_request.dart';
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

  Future<Response> signup(SignupRequest request) async {

  return await DioClient.dio.post(
    "/auth/signup",
    data: request.toJson(),
  );

}
Future<Response> forgetPassword(
    ForgetPasswordRequest request) async {

  return await DioClient.dio.post(
    "/auth/forgot-password",
    data: request.toJson(),
  );

}

}