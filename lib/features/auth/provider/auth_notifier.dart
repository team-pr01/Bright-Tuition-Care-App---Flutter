import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/features/auth/data/auth_api.dart';
import 'package:btcclient/features/auth/data/auth_repository.dart';
import 'package:btcclient/features/auth/data/models/signup_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btcclient/features/auth/data/models/forgot_password_request.dart';
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
      final user =
        await LocalStorage.getUser();


      if (token != null) {
        state = AuthState(loggedIn: true, role: role,user:user ,loading: false);
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

  Future<void> forgetPassword(ForgetPasswordRequest request) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final result = await repo.forgetPassword(request);

      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
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

print("Saved user name: ${result.user.name}");
      state = AuthState(loggedIn: true, role: result.role, loading: false,user: result.user);
    
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
}
