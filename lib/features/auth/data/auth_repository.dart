class AuthResult {

  final String token;
  final String role;

  AuthResult({
    required this.token,
    required this.role,
  });

}

class AuthRepository {

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {

    /// TODO replace with Dio call

    await Future.delayed(const Duration(seconds: 1));

    return AuthResult(
      token: "dummy_token",
      role: "guardian",
    );

  }

}
