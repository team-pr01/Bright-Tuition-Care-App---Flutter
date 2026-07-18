import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/features/auth/data/auth_api.dart';
import 'package:btcclient/features/auth/data/auth_repository.dart';
import 'package:btcclient/features/auth/data/requests/resend_forgot_password_otp_request.dart';
import 'package:btcclient/features/auth/data/requests/resend_otp_request.dart';
import 'package:btcclient/features/auth/data/requests/reset_password_request.dart';
import 'package:btcclient/features/auth/data/requests/signup_request.dart';
import 'package:btcclient/features/auth/data/requests/verify_otp_request.dart';
import 'package:btcclient/features/auth/data/requests/verify_reset_password_otp_request.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btcclient/features/auth/data/requests/forgot_password_request.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(AuthApi()));

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.read(authRepositoryProvider);

  return AuthNotifier(repo, ref); // 🔥 pass ref
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repo;
  final Ref ref; // 🔥 add this

  AuthNotifier(this.repo, this.ref)
    : super(const AuthState(loggedIn: false, loading: true)) {
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    try {
      final token = await LocalStorage.getToken();
      final role = await LocalStorage.getRole();
      final user = await LocalStorage.getUser();

      if (token != null) {
        await ref.read(profileProvider.notifier).fetchProfile();
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
      state = AuthState(
        loggedIn: false,
        loading: false,
        error: ApiErrorHandler.getMessage(e),
      );
    }
  }

 Future<bool> signup(SignupRequest request) async {
  state = state.copyWith(
    loading: true,
    error: null,
  );

  try {
    await repo.signup(request);

    state = state.copyWith(
      loading: false,
    );

    return true;
  } catch (e) {
    state = state.copyWith(
      loading: false,
      error: ApiErrorHandler.getMessage(e),
    );

    return false;
  }
}

  Future<bool> forgetPassword({required String phoneNumber}) async {
    try {
      state = state.copyWith(loading: true, error: null);
      await repo.forgetPassword(
        ForgetPasswordRequest(phoneNumber: phoneNumber),
      );

      /// SAVE identifier here
      await LocalStorage.saveAuthIdentifier(phoneNumber);
      state = state.copyWith(loading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: ApiErrorHandler.getMessage(e),
      );

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
      await ref.read(profileProvider.notifier).fetchProfile();
      await LocalStorage.setWelcomeSeen();
      await LocalStorage.saveUser(result.user);
      state = AuthState(
        loggedIn: true,
        role: result.role,
        loading: false,
        user: result.user,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: ApiErrorHandler.getMessage(e),
      );
    }
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    await LocalStorage.clearSession();

    state = const AuthState(loggedIn: false, loading: false);
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final result = await repo.verifyOtp(
        VerifyOtpRequest(email: email, otp: otp),
      );
      await LocalStorage.setWelcomeSeen();
      await ref.read(profileProvider.notifier).fetchProfile();

      /// set full auth state
      state = AuthState(
        loggedIn: true,
        role: result.role,
        user: result.user,
        loading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: ApiErrorHandler.getMessage(e),
      );

      return false;
    }
  }

  Future<bool> resendOtp({required String email}) async {
    try {
      state = state.copyWith(loading: true, error: null);

      await repo.resendOtp(ResendOtpRequest(email: email));

      state = state.copyWith(loading: false);

      return true;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: ApiErrorHandler.getMessage(e),
      );

      return false;
    }
  }

  Future<bool> verifyResetPasswordOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      state = state.copyWith(loading: true, error: null);

      await repo.verifyResetPasswordOtp(
        VerifyResetPasswordOtpRequest(phoneNumber: phoneNumber, otp: otp),
      );

      state = state.copyWith(loading: false);

      return true;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: ApiErrorHandler.getMessage(e),
      );

      return false;
    }
  }

  Future<bool> resendForgotPasswordOtp({required String phoneNumber}) async {
    try {
      state = state.copyWith(loading: true, error: null);

      await repo.resendForgotPasswordOtp(
        ResendForgotPasswordOtpRequest(phoneNumber: phoneNumber),
      );

      state = state.copyWith(loading: false);

      return true;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: ApiErrorHandler.getMessage(e),
      );

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
      await ref.read(profileProvider.notifier).fetchProfile();
      return true;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: ApiErrorHandler.getMessage(e),
      );

      return false;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> body) async {
    try {
      state = state.copyWith(loading: true, error: null);

      final updatedProfile = await repo.updateProfile(body);
      await ref.read(profileProvider.notifier).fetchProfile();

      state = state.copyWith(loading: false);

      return true;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: ApiErrorHandler.getMessage(e),
      );

      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      state = state.copyWith(loading: true, error: null);

      final success = await repo.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      state = state.copyWith(loading: false);

      return success;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: ApiErrorHandler.getMessage(e),
      );

      return false;
    }
  }

  Future<bool> requestUnlockProfile(String reason) async {
    try {
      state = state.copyWith(loading: true, error: null);

      print("🚀 REQUEST UNLOCK API CALLED");

      print("📤 REASON: $reason");

      final success = await repo.requestUnlockProfile(reason);

      /// REFRESH PROFILE
      await ref.read(profileProvider.notifier).fetchProfile();

      state = state.copyWith(loading: false);

      return success;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: ApiErrorHandler.getMessage(e),
      );

      return false;
    }
  }
}
