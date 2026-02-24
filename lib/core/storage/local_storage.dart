import 'package:btcclient/features/auth/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class LocalStorage {

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  static const String _keyToken = 'token';
  static const String _keyRefreshToken = 'refreshToken';
  static const String _keyRole = 'role';
  static const String _keyWelcome = 'welcome';
  static const String _keyAuthIdentifier = 'authIdentifier';
 static const String _keyUser = "user";

static Future<void> saveUser(UserModel user) async {

    final jsonString =
        jsonEncode(user.toJson());

    await _storage.write(
      key: _keyUser,
      value: jsonString,
    );

  }

  static Future<UserModel?> getUser() async {

    final jsonString =
        await _storage.read(key: _keyUser);

    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap =
        jsonDecode(jsonString);

    return UserModel.fromJson(jsonMap);

  }

  static Future<void> clearUser() async {

    await _storage.delete(key: _keyUser);

  }

  // TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }


  // REFRESH TOKEN
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }


  // ROLE
  static Future<void> saveRole(String role) async {
    await _storage.write(key: _keyRole, value: role);
  }

  static Future<String?> getRole() async {
    return await _storage.read(key: _keyRole);
  }


  // WELCOME FLAG
  static Future<void> setWelcomeSeen() async {
    await _storage.write(key: _keyWelcome, value: 'true');
  }

  static Future<bool> isWelcomeSeen() async {
    return (await _storage.read(key: _keyWelcome)) == 'true';
  }

  static Future<void> clearWelcome() async {
    await _storage.delete(key: _keyWelcome);
  }


  // AUTH IDENTIFIER (email or phone)
  static Future<void> saveAuthIdentifier(String value) async {
    await _storage.write(
      key: _keyAuthIdentifier,
      value: value,
    );
  }

  static Future<String?> getAuthIdentifier() async {
    return await _storage.read(
      key: _keyAuthIdentifier,
    );
  }

  static Future<void> clearAuthIdentifier() async {
    await _storage.delete(
      key: _keyAuthIdentifier,
    );
  }


  // CLEAR ALL
  static Future<void> clear() async {
    await _storage.deleteAll();
  }

}