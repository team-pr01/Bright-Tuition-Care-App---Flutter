import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage.dart';
import 'auth_state.dart';

final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {

  AuthNotifier()
      : super(const AuthState(
          loggedIn: false,
          loading: true,
        )) {
    _load();
  }

  Future<void> _load() async {

    try {

      final token = await LocalStorage.getToken();
      final role = await LocalStorage.getRole();

      state = AuthState(
        loggedIn: token != null,
        role: role,
        loading: false,
      );

    } catch (e) {

      state = AuthState(
        loggedIn: false,
        loading: false,
        error: e.toString(),
      );
    }
  }

  /// REAL LOGIN ENTRY POINT
  Future<void> login({
    required String email,
    required String password,
  }) async {

    state = state.copyWith(
      loading: true,
      error: null,
    );

    try {

      /// TODO replace with API call
      await Future.delayed(const Duration(seconds: 1));

      const token = "token123";
      const role = "guardian";

      await LocalStorage.saveToken(token);
      await LocalStorage.saveRole(role);

      state = AuthState(
        loggedIn: true,
        role: role,
        loading: false,
      );

    } catch (e) {

      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {

    await LocalStorage.clear();

    state = const AuthState(
      loggedIn: false,
    );
  }
}
