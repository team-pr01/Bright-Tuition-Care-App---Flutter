class AuthResult {

  final String token;
  final String role;

  AuthResult({
    required this.token,
    required this.role,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {

    final token = json["token"] ?? json["accessToken"];

    final role =
        json["user"]?["role"] ??
        json["role"];

    if (token == null) {
      throw Exception("Token missing");
    }

    return AuthResult(
      token: token,
      role: role,
    );
  }
}