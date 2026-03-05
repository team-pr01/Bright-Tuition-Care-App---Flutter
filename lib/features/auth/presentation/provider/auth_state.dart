import 'package:btcclient/features/auth/data/models/user_model.dart';

class AuthState {
  final bool loggedIn;
  final String? role;
  final bool loading;
  final String? error;
  final UserModel? user;

  const AuthState({
    required this.loggedIn,
    this.role,
    this.loading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? loggedIn,
    String? role,
    bool? loading,
    String? error,
    UserModel? user,
  }) {
    return AuthState(
      loggedIn: loggedIn ?? this.loggedIn,
      role: role ?? this.role,
      loading: loading ?? this.loading,
      error: error,
      user: user ?? this.user,
    );
  }
}
