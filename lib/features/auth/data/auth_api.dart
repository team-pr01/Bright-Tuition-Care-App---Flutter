import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:btcclient/core/network/api_exception.dart';
import 'package:btcclient/features/auth/data/requests/resend_forgot_password_otp_request.dart';
import 'package:btcclient/features/auth/data/requests/resend_otp_request.dart';
import 'package:btcclient/features/auth/data/requests/reset_password_request.dart';
import 'package:btcclient/features/auth/data/requests/signup_request.dart';
import 'package:btcclient/features/auth/data/requests/forgot_password_request.dart';
import 'package:btcclient/features/auth/data/requests/verify_otp_request.dart';
import 'package:btcclient/features/auth/data/requests/verify_reset_password_otp_request.dart';
import 'package:btcclient/features/profile/data/requests/update_personal_info_request.dart';
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
      data: {"email": email, "password": password, "role": role},
    );
  }

  Future<Response> signup(SignupRequest request) async {
    return await DioClient.dio.post("/auth/signup", data: request.toJson());
  }

  Future<Response> forgetPassword(ForgetPasswordRequest request) async {
    return await DioClient.dio.post(
      "/auth/forgot-password",
      data: request.toJson(),
    );
  }

  Future<Response> verifyOtp(VerifyOtpRequest request) async {
    return await DioClient.dio.post("/auth/verify-otp", data: request.toJson());
  }

  Future<Response> resendOtp(ResendOtpRequest request) async {
    return await DioClient.dio.post("/auth/resend-otp", data: request.toJson());
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

  Future<Response> resetPassword(ResetPasswordRequest request) async {
    return await DioClient.dio.post(
      "/auth/reset-password",
      data: request.toJson(),
    );
  }

  Future<Response> getMe() async {
    return await DioClient.dio.get("/user/me");
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    return await DioClient.dio.patch("/user/update-profile", data: data);
  }

  Future<Response> getTutorTestimonials() async {
    return DioClient.dio.get(
      "/testimonial/tutors",
      options: Options(receiveTimeout: const Duration(seconds: 60)),
    );
  }

  Future<Response> getGuardianTestimonials() async {
    return await DioClient.dio.get(
      "/testimonial/guardians",
      options: Options(receiveTimeout: const Duration(seconds: 60)),
    );
  }

  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await DioClient.dio.post(
      "/auth/change-password",
      data: {"currentPassword": currentPassword, "newPassword": newPassword},
    );
  }

  Future<Response> requestUnlockProfile({required String reason}) async {
    return await DioClient.dio.patch(
      "/user/request-to-unlock-profile",
      data: {"unlockRequestReason": reason},
    );
  }
  Future<void> updatePersonalInfo(
  UpdatePersonalInfoRequest request,
) async {
  try {
    await DioClient.dio.patch(
      "/user/update-profile",
      data: request.toJson(),
    );
  } on DioException catch (e) {
    throw ApiException(ApiErrorHandler.getMessage(e));
  } catch (e) {
    throw ApiException(ApiErrorHandler.getMessage(e));
  }
}}
