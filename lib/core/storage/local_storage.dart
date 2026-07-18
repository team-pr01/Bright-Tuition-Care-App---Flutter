import 'package:btcclient/features/auth/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class LocalStorage {
  LocalStorage._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // ==========================
  // Storage Keys
  // ==========================

  static const String _keyToken = "token";
  static const String _keyRefreshToken = "refreshToken";
  static const String _keyRole = "role";
  static const String _keyUser = "user";

  static const String _keyWelcome = "welcome";
  static const String _keyAuthIdentifier = "authIdentifier";

  // ==========================
  // Access Token
  // ==========================

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _keyToken);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _keyToken);
  }

  // ==========================
  // Refresh Token
  // ==========================

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return _storage.read(key: _keyRefreshToken);
  }

  static Future<void> clearRefreshToken() async {
    await _storage.delete(key: _keyRefreshToken);
  }

  // ==========================
  // Role
  // ==========================

  static Future<void> saveRole(String role) async {
    await _storage.write(key: _keyRole, value: role);
  }

  static Future<String?> getRole() async {
    return _storage.read(key: _keyRole);
  }

  static Future<void> clearRole() async {
    await _storage.delete(key: _keyRole);
  }

  // ==========================
  // User
  // ==========================

  static Future<void> saveUser(UserModel user) async {
    await _storage.write(key: _keyUser, value: jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final json = await _storage.read(key: _keyUser);
 print(json);
    if (json == null) return null;

    return UserModel.fromJson(jsonDecode(json));
  }

  static Future<void> clearUser() async {
    await _storage.delete(key: _keyUser);
  }

  // ==========================
  // Welcome Flag
  // ==========================

  static Future<void> setWelcomeSeen() async {
    await _storage.write(key: _keyWelcome, value: "true");
  }

  static Future<bool> isWelcomeSeen() async {
    return (await _storage.read(key: _keyWelcome)) == "true";
  }

  static Future<void> clearWelcome() async {
    await _storage.delete(key: _keyWelcome);
  }

  // ==========================
  // Auth Identifier
  // ==========================

  static Future<void> saveAuthIdentifier(String value) async {
    await _storage.write(key: _keyAuthIdentifier, value: value);
  }

  static Future<String?> getAuthIdentifier() async {
    return _storage.read(key: _keyAuthIdentifier);
  }

  static Future<void> clearAuthIdentifier() async {
    await _storage.delete(key: _keyAuthIdentifier);
  }

  // ==========================
  // Session
  // ==========================

  static Future<void> clearSession() async {
    await Future.wait([
      clearToken(),
      clearRefreshToken(),
      clearRole(),
      clearUser(),
      clearAuthIdentifier(),
    ]);
  }

  // ==========================
  // Clear Everything
  // ==========================

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
