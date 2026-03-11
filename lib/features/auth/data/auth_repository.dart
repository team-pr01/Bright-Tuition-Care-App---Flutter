import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/features/auth/data/auth_api.dart';
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

class AuthResult {
  final String token;
  final String role;
  final UserModel user;
  final String? refreshToken;
  AuthResult({required this.token, required this.role, required this.user, this.refreshToken});
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
      throw Exception(responseData["message"]);
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

    return AuthResult(token: accessToken, role: user.role, user: user, refreshToken: refreshToken);
  }

  Future<SignupResult> signup(SignupRequest request) async {
    final response = await api.signup(request);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw Exception(responseData["message"]);
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

Future<VerifyResetPasswordOtpResult>
verifyResetPasswordOtp(
  VerifyResetPasswordOtpRequest request,
) async {

  final response =
      await api.verifyResetPasswordOtp(
        request,
      );

  final responseData =
      response.data;

  if (responseData["success"] != true) {

    throw Exception(
      responseData["message"] ??
      "OTP verification failed",
    );

  }

  return VerifyResetPasswordOtpResult
      .fromJson(responseData);

}


Future<ResendForgotPasswordOtpResult>
resendForgotPasswordOtp(
  ResendForgotPasswordOtpRequest request,
) async {

  final response =
      await api.resendForgotPasswordOtp(
        request,
      );

  final responseData =
      response.data;
      print(responseData);

  if (responseData["success"] != true) {

    throw Exception(
      responseData["message"] ??
      "Failed to resend OTP",
    );

  }

  return ResendForgotPasswordOtpResult
      .fromJson(responseData);

}

Future<ResetPasswordResult> resetPassword(
  ResetPasswordRequest request,
) async {

  final response =
      await api.resetPassword(request);

  final responseData =
      response.data;

  if (responseData["success"] != true) {

    throw Exception(
      responseData["message"] ??
      "Reset password failed",
    );

  }

  return ResetPasswordResult.fromJson(
    responseData,
  );

}

}
