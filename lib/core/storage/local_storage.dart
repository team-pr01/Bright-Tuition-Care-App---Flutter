import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) =>
      _storage.write(key: 'token', value: token);

  static Future<String?> getToken() => _storage.read(key: 'token');
  
  static Future<void> saveRefreshToken(String token) =>
      _storage.write(key: 'refreshToken', value: token);

  static Future<String?> getRefreshToken() =>
      _storage.read(key: 'refreshToken');
  static Future<void> setWelcomeSeen() =>
      _storage.write(key: 'welcome', value: 'true');

  static Future<bool> isWelcomeSeen() async =>
      (await _storage.read(key: 'welcome')) == 'true';

  static Future<void> clear() => _storage.deleteAll();

  static Future<void> saveRole(String role) =>
      _storage.write(key: 'role', value: role);

  static Future<String?> getRole() => _storage.read(key: 'role');

  // dev
  static Future<void> clearWelcome() => _storage.delete(key: 'welcome');
}
