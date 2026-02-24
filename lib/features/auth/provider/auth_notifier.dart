import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/features/auth/data/auth_api.dart';
import 'package:btcclient/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';

final authRepositoryProvider =
Provider((ref) => AuthRepository(AuthApi()));

final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final repo = ref.read(authRepositoryProvider);

  return AuthNotifier(repo);

});

class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository repo;

  AuthNotifier(this.repo)
      : super(const AuthState(
          loggedIn: false,
          loading: true,
        )) {
    _checkLogin();
  }

  // ================= RESTORE LOGIN =================

  Future<void> _checkLogin() async {

    try {

      final token = await LocalStorage.getToken();
      final role = await LocalStorage.getRole();

      if (token != null) {

        state = AuthState(
          loggedIn: true,
          role: role,
          loading: false,
        );

      } else {

        state = const AuthState(
          loggedIn: false,
          loading: false,
        );

      }

    } catch (e) {

      state = AuthState(
        loggedIn: false,
        loading: false,
        error: e.toString(),
      );

    }

  }

  // ================= LOGIN =================

  Future<void> login({
    required String email,
    required String password,
    required String role,
  }) async {

    state = state.copyWith(
      loading: true,
      error: null,
    );

    try {

      final result = await repo.login(
        email: email,
        password: password,
        role: role,
      );

      state = AuthState(
        loggedIn: true,
        role: result.role,
        loading: false,
      );

    } catch (e) {

      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );

    }

  }

  // ================= LOGOUT =================

  Future<void> logout() async {

    await LocalStorage.clear();

    state = const AuthState(
      loggedIn: false,
      loading: false,
    );

  }

}