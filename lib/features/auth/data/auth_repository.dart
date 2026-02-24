import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/features/auth/data/auth_api.dart';
import 'package:btcclient/features/auth/data/models/forgot_password_request.dart';
import 'package:btcclient/features/auth/data/models/forgot_password_result.dart';
import 'package:btcclient/features/auth/data/models/resend_otp_request.dart';
import 'package:btcclient/features/auth/data/models/resend_otp_result.dart';
import 'package:btcclient/features/auth/data/models/signup_request.dart';
import 'package:btcclient/features/auth/data/models/signup_result.dart';
import 'package:btcclient/features/auth/data/models/user_model.dart';
import 'package:btcclient/features/auth/data/models/verify_otp_request.dart';
import 'package:btcclient/features/auth/data/models/verify_otp_result.dart';

class AuthResult {
  final String token;
  final String role;
  final UserModel user;
  AuthResult({required this.token, required this.role, required this.user});
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

    return AuthResult(token: accessToken, role: user.role, user: user);
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
}
