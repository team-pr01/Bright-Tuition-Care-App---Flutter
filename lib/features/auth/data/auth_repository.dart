import 'dart:io';

import 'package:btcclient/core/network/api_exception.dart';
import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/core/utils/notification_service.dart';
import 'package:btcclient/features/auth/data/auth_api.dart';
import 'package:btcclient/features/auth/data/models/guardian_model.dart';
import 'package:btcclient/features/auth/data/models/testimonial_model.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/auth/data/requests/education_request.dart';
import 'package:btcclient/features/auth/data/requests/forgot_password_request.dart';
import 'package:btcclient/features/auth/data/results/forgot_password_result.dart';
import 'package:btcclient/features/auth/data/requests/resend_forgot_password_otp_request.dart';
import 'package:btcclient/features/auth/data/results/resend_forgot_password_otp_result.dart';
import 'package:btcclient/features/auth/data/requests/resend_otp_request.dart';
import 'package:btcclient/features/auth/data/results/resend_otp_result.dart';
import 'package:btcclient/features/auth/data/requests/reset_password_request.dart';
import 'package:btcclient/features/auth/data/results/reset_password_result.dart';
import 'package:btcclient/features/auth/data/requests/signup_request.dart';
import 'package:btcclient/features/auth/data/results/signup_result.dart';
import 'package:btcclient/features/auth/data/models/user_model.dart';
import 'package:btcclient/features/auth/data/requests/verify_otp_request.dart';
import 'package:btcclient/features/auth/data/requests/verify_reset_password_otp_request.dart';
import 'package:btcclient/features/auth/data/results/verify_reset_password_otp_result.dart';
import 'package:btcclient/features/profile/data/requests/update_personal_info_request.dart';
import 'package:dio/dio.dart';

class AuthResult {
  final String token;
  final String role;
  final UserModel user;
  final String? refreshToken;
  AuthResult({
    required this.token,
    required this.role,
    required this.user,
    this.refreshToken,
  });
}

class AuthRepository {
  final AuthApi api;

  AuthRepository(this.api);

  Future<AuthResult> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await api.login(
      email: email,
      password: password,
      role: role,
    );

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(responseData["message"]);
    }

    final data = responseData["data"];

    final accessToken = data["accessToken"];
    final refreshToken = data["refreshToken"];

    /// THIS IS THE MOST IMPORTANT FIX
    final userJson = data["user"];

    final user = UserModel.fromJson(userJson);

    await LocalStorage.saveToken(accessToken);
    await LocalStorage.saveRefreshToken(refreshToken);
    await LocalStorage.saveRole(user.role);

    // 🔥 Register FCM after authentication
    await NotificationService().registerFcmToken();
    return AuthResult(
      token: accessToken,
      role: user.role,
      user: user,
      refreshToken: refreshToken,
    );
  }

  Future<SignupResult> signup(SignupRequest request) async {
    final response = await api.signup(request);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(responseData["message"]);
    }

    final data = responseData["data"];

    return SignupResult.fromJson(data);
  }

  Future<ForgotPasswordResult> forgetPassword(
    ForgetPasswordRequest request,
  ) async {
    final response = await api.forgetPassword(request);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw Exception(responseData["message"] ?? "Forgot password failed");
    }

    final data = responseData["data"];

    return ForgotPasswordResult.fromJson(
      data ?? {"message": responseData["message"]},
    );
  }

  Future<AuthResult> verifyOtp(VerifyOtpRequest request) async {
    final response = await api.verifyOtp(request);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw Exception(responseData["message"] ?? "OTP verification failed");
    }

    final data = responseData["data"];

    if (data == null) {
      throw Exception("Invalid response");
    }
    final accessToken = data["accessToken"];

    final refreshToken = data["refreshToken"];

    final userJson = data["user"];

    final user = UserModel.fromJson(userJson);

    /// Save everything
    await LocalStorage.saveToken(accessToken);

    await LocalStorage.saveRefreshToken(refreshToken);

    await LocalStorage.saveRole(user.role);

    await LocalStorage.saveUser(user);
    await NotificationService().registerFcmToken();

    /// return AuthResult (same as login)
    return AuthResult(token: accessToken, role: user.role, user: user);
  }

  Future<ResendOtpResult> resendOtp(ResendOtpRequest request) async {
    final response = await api.resendOtp(request);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw Exception(responseData["message"] ?? "Resend OTP failed");
    }

    return ResendOtpResult.fromJson(responseData);
  }

  Future<VerifyResetPasswordOtpResult> verifyResetPasswordOtp(
    VerifyResetPasswordOtpRequest request,
  ) async {
    final response = await api.verifyResetPasswordOtp(request);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw Exception(responseData["message"] ?? "OTP verification failed");
    }

    return VerifyResetPasswordOtpResult.fromJson(responseData);
  }

  Future<ResendForgotPasswordOtpResult> resendForgotPasswordOtp(
    ResendForgotPasswordOtpRequest request,
  ) async {
    final response = await api.resendForgotPasswordOtp(request);

    final responseData = response.data;
    print(responseData);

    if (responseData["success"] != true) {
      throw Exception(responseData["message"] ?? "Failed to resend OTP");
    }

    return ResendForgotPasswordOtpResult.fromJson(responseData);
  }

  Future<ResetPasswordResult> resetPassword(
    ResetPasswordRequest request,
  ) async {
    final response = await api.resetPassword(request);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw Exception(responseData["message"] ?? "Reset password failed");
    }

    return ResetPasswordResult.fromJson(responseData);
  }

  Future<dynamic> getProfile() async {
    final response = await api.getMe();

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(responseData["message"]);
    }

    final data = responseData["data"];
    final role = data["userId"]?["role"];

    if (role == "guardian") {
      return GuardianProfileModel.fromJson(responseData);
    } else if (role == "tutor") {
      return TutorProfileModel.fromJson(responseData);
    } else {
      throw Exception("Unknown role");
    }
  }

  Future<dynamic> updateProfile(Map<String, dynamic> body) async {
    final response = await api.updateProfile(body);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(responseData["message"]);
    }

    final role = responseData["data"]?["userId"]?["role"];

    if (role == "guardian") {
      return GuardianProfileModel.fromJson(responseData);
    } else if (role == "tutor") {
      return TutorProfileModel.fromJson(responseData);
    } else {
      throw Exception("Unknown role");
    }
  }

  Future<List<TestimonialModel>> getAllTestimonials() async {
    final responses = await Future.wait([
      api.getTutorTestimonials(),
      api.getGuardianTestimonials(),
    ]);

    final tutorRes = responses[0];
    final guardianRes = responses[1];

    final tutorData = (tutorRes.data["data"] ?? []) as List;
    final guardianData = (guardianRes.data["data"] ?? []) as List;

    final tutors = tutorData.map((e) => TestimonialModel.fromJson(e)).toList();

    final guardians = guardianData
        .map((e) => TestimonialModel.fromJson(e))
        .toList();

    final combined = [...tutors, ...guardians];

    combined.shuffle();

    return combined;
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await api.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(responseData["message"]);
    }

    return true;
  }

  Future<bool> requestUnlockProfile(String reason) async {
    final response = await api.requestUnlockProfile(reason: reason);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(responseData["message"]);
    }

    return true;
  }

  Future<void> updatePersonalInfo(UpdatePersonalInfoRequest request) async {
    await api.updatePersonalInfo(request);
  }

  Future<void> updateProfileImage(File image) {
    return api.updateProfileImage(image);
  }

  Future<void> addEducation(EducationRequest request) async {
    print("Adding education2: ${request.toJson()}");
    await api.addEducation(request);
  }

  Future<void> updateEducation({
    required String id,
    required EducationRequest request,
  }) async {
    await api.updateEducation(id: id, request: request);
  }

  Future<void> deleteEducation(String id) async {
    await api.deleteEducation(id);
  }

  Future<void> updateIdentityInfo({
    required String fileType,
    required File file,
  }) async {
    final formData = FormData.fromMap({
      "fileType": fileType,
      "file": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });
    

    final response = await api.updateIdentityInfo(formData);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(
        responseData["message"] ?? "Identity information update failed",
      );
    }
  }

Future<bool> requestTutor({
      required String guardianPhoneNumber,
      required String tutorClass,
      String? userId,
      String? tutorId,
    }) async {
      final response = await api.requestTutor(
        guardianPhoneNumber: guardianPhoneNumber,
        tutorClass: tutorClass,
        userId: userId,
        tutorId: tutorId,
      );

      final responseData = response.data;

      if (responseData["success"] != true) {
        throw ApiException(
          responseData["message"] ?? "Failed to request tutor",
        );
      }

      return true;
    }
  Future<void> deleteIdentityInfo(String id) async {
    final response = await api.deleteIdentityInfo(id);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(
        responseData["message"] ?? "Failed to delete identity information",
      );
    }
  }
}
