import 'package:btcclient/core/storage/local_storage.dart';
import 'package:btcclient/features/auth/data/auth_api.dart';

class AuthResult {
  final String token;
  final String role;

  AuthResult({required this.token, required this.role});
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

  print("LOGIN RESPONSE:");
  print(response.data);

  final responseData = response.data;

  if (responseData["success"] != true) {
    throw Exception(responseData["message"] ?? "Login failed");
  }

  final data = responseData["data"];

  if (data == null) {
    throw Exception("Data object missing in response");
  }

  final accessToken = data["accessToken"];
  final refreshToken = data["refreshToken"];
  final userRole = data["role"] ?? role;

  if (accessToken == null) {
    throw Exception("Access token missing");
  }

await LocalStorage.saveToken(accessToken);
await LocalStorage.saveRefreshToken(refreshToken);
  await LocalStorage.saveRole(userRole);

  return AuthResult(
    token: accessToken,
    role: userRole,
  );

}


}
