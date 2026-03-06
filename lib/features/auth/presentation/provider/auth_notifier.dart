import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/features/auth/data/auth_api.dart';
import 'package:btcclient/features/auth/data/auth_repository.dart';
import 'package:btcclient/features/auth/data/models/requests/resend_forgot_password_otp_request.dart';
import 'package:btcclient/features/auth/data/models/requests/resend_otp_request.dart';
import 'package:btcclient/features/auth/data/models/requests/reset_password_request.dart';
import 'package:btcclient/features/auth/data/models/requests/signup_request.dart';
import 'package:btcclient/features/auth/data/models/requests/verify_otp_request.dart';
import 'package:btcclient/features/auth/data/models/requests/verify_reset_password_otp_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btcclient/features/auth/data/models/requests/forgot_password_request.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(AuthApi()));

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.read(authRepositoryProvider);

  return AuthNotifier(repo);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repo;

  AuthNotifier(this.repo)
    : super(const AuthState(loggedIn: false, loading: true)) {
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    try {
      final token = await LocalStorage.getToken();
      final role = await LocalStorage.getRole();
      final user = await LocalStorage.getUser();

      if (token != null) {
        state = AuthState(
          loggedIn: true,
          role: role,
          user: user,
          loading: false,
        );
      } else {
        state = const AuthState(loggedIn: false, loading: false);
      }
    } catch (e) {
      state = AuthState(loggedIn: false, loading: false, error: e.toString());
    }
  }

  Future<void> signup(SignupRequest request) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final result = await repo.signup(request);

      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<bool> forgetPassword({required String phoneNumber}) async {
    try {
      await repo.forgetPassword(
        ForgetPasswordRequest(phoneNumber: phoneNumber),
      );

      /// SAVE identifier here
      await LocalStorage.saveAuthIdentifier(phoneNumber);

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());

      return false;
    }
  }

  // ================= LOGIN =================

  Future<void> login({
    required String email,
    required String password,
    required String role,
  }) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final result = await repo.login(
        email: email,
        password: password,
        role: role,
      );
      await LocalStorage.setWelcomeSeen();
      await LocalStorage.saveUser(result.user);
      final savedUser = await LocalStorage.getUser();
      state = AuthState(
        loggedIn: true,
        role: result.role,
        loading: false,
        user: result.user,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    await LocalStorage.clearUser();
    await LocalStorage.clear();
    
    state = const AuthState(loggedIn: false, loading: false);
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final result = await repo.verifyOtp(
        VerifyOtpRequest(email: email, otp: otp),
      );

      /// set full auth state
      state = AuthState(
        loggedIn: true,
        role: result.role,
        user: result.user,
        loading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());

      return false;
    }
  }

  Future<bool> resendOtp({required String email}) async {
    try {
      await repo.resendOtp(ResendOtpRequest(email: email));

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());

      return false;
    }
  }

  Future<bool> verifyResetPasswordOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      print("Verifying OTP for phone: $phoneNumber with OTP: $otp");
      final result = await repo.verifyResetPasswordOtp(
        VerifyResetPasswordOtpRequest(phoneNumber: phoneNumber, otp: otp),
      );
      print("Verify Reset Password OTP Result: ${result.message}");
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());

      return false;
    }
  }

  Future<bool> resendForgotPasswordOtp({required String phoneNumber}) async {
    try {
      final result = await repo.resendForgotPasswordOtp(
        ResendForgotPasswordOtpRequest(phoneNumber: phoneNumber),
      );
      print(result);

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());

      return false;
    }
  }

  Future<bool> resetPassword({
    required String phoneNumber,
    required String newPassword,
  }) async {
    try {
      state = state.copyWith(loading: true, error: null);

      await repo.resetPassword(
        ResetPasswordRequest(
          phoneNumber: phoneNumber,
          newPassword: newPassword,
        ),
      );

      state = state.copyWith(loading: false);

      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());

      return false;
    }
  }
}
