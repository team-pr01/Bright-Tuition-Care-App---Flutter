import 'package:btcclient/features/auth/data/models/resend_forgot_password_otp_request.dart';
import 'package:btcclient/features/auth/data/models/resend_otp_request.dart';
import 'package:btcclient/features/auth/data/models/reset_password_request.dart';
import 'package:btcclient/features/auth/data/models/signup_request.dart';
import 'package:btcclient/features/auth/data/models/forgot_password_request.dart';
import 'package:btcclient/features/auth/data/models/verify_otp_request.dart';
import 'package:btcclient/features/auth/data/models/verify_reset_password_otp_request.dart';
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

Future<Response> verifyOtp(
  VerifyOtpRequest request,
) async {

  return await DioClient.dio.post(
    "/auth/verify-otp",
    data: request.toJson(),
  );

}

Future<Response> resendOtp(
  ResendOtpRequest request,
) async {

  return await DioClient.dio.post(
    "/auth/resend-otp",
    data: request.toJson(),
  );

}

Future<Response> verifyResetPasswordOtp(
  VerifyResetPasswordOtpRequest request,
) async {

  return await DioClient.dio.post(
    "/auth/verify-reset-password-otp",
    data: request.toJson(),
  );

}

Future<Response> resendForgotPasswordOtp(
  ResendForgotPasswordOtpRequest request,
) async {

  return await DioClient.dio.post(
    "/auth/resend-forgot-password-otp",
    data: request.toJson(),
  );

}

Future<Response> resetPassword(
  ResetPasswordRequest request,
) async {

  return await DioClient.dio.post(
    "/auth/reset-password",
    data: request.toJson(),
  );

}

}