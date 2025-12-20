import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String tokenKey = 'jwt_token';
  static const String userIdKey = 'user_id';

  Future<void> createSession({
    String? token,
    String? userId,
    Map<String, dynamic>? extra,
  }) async {
    // Save sensitive values if provided
    if (token != null) {
      await _secureStorage.write(key: tokenKey, value: token);
    }

    if (userId != null) {
      await _secureStorage.write(key: userIdKey, value: userId);
    }

    // Save non-sensitive extra values in SharedPreferences
    if (extra != null && extra.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      for (var entry in extra.entries) {
        final key = entry.key;
        final value = entry.value;
        if (value == null) continue;

        await prefs.setString(key, value.toString());
      }
    }
  }

  Future<dynamic> getSession({String? key}) async {
    if (key != null) {
      final secureValue = await _secureStorage.read(key: key);
      if (secureValue != null) return secureValue;

      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }

    final Map<String, String> sessionData = {};

    final allSecureKeys = await _secureStorage.readAll();
    sessionData.addAll(allSecureKeys);

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (var k in keys) {
      sessionData[k] = prefs.getString(k) ?? '';
    }

    return sessionData;
  }

  Future<bool> hasSession() async {
    final token = await getSession();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearSession({List<String>? extraKeys}) async {
    await _secureStorage.delete(key: tokenKey);
    await _secureStorage.delete(key: userIdKey);

    if (extraKeys != null && extraKeys.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      for (var key in extraKeys) {
        await prefs.remove(key);
      }
    }
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
