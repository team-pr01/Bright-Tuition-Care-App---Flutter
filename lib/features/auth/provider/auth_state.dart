class AuthState {

  final bool loggedIn;
  final String? role;
  final bool loading;
  final String? error;

  const AuthState({
    required this.loggedIn,
    this.role,
    this.loading = false,
    this.error,
  });

  AuthState copyWith({
    bool? loggedIn,
    String? role,
    bool? loading,
    String? error,
  }) {
    return AuthState(
      loggedIn: loggedIn ?? this.loggedIn,
      role: role ?? this.role,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
