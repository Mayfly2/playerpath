import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static FlutterSecureStorage? _storage;
  static final Map<String, String> _memoryFallback = {};

  static Future<void> init() async {
    try {
      _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );
      // Test write to confirm it works
      await _storage!.write(key: '_test', value: 'ok');
      await _storage!.delete(key: '_test');
    } catch (e) {
      debugPrint('SecureStorage init failed, using memory fallback: $e');
      _storage = null;
    }
  }

  static Future<void> setAccessToken(String token) async {
    _memoryFallback['access_token'] = token;
    try {
      await _storage?.write(key: 'access_token', value: token);
    } catch (_) {}
  }

  static Future<String?> getAccessToken() async {
    try {
      final stored = await _storage?.read(key: 'access_token');
      if (stored != null) return stored;
    } catch (_) {}
    return _memoryFallback['access_token'];
  }

  static Future<void> setRefreshToken(String token) async {
    _memoryFallback['refresh_token'] = token;
    try {
      await _storage?.write(key: 'refresh_token', value: token);
    } catch (_) {}
  }

  static Future<String?> getRefreshToken() async {
    try {
      final stored = await _storage?.read(key: 'refresh_token');
      if (stored != null) return stored;
    } catch (_) {}
    return _memoryFallback['refresh_token'];
  }

  static Future<void> clearTokens() async {
    _memoryFallback.remove('access_token');
    _memoryFallback.remove('refresh_token');
    try {
      await _storage?.delete(key: 'access_token');
      await _storage?.delete(key: 'refresh_token');
    } catch (_) {}
  }

  static Future<void> clearAll() async {
    _memoryFallback.clear();
    try {
      await _storage?.deleteAll();
    } catch (_) {}
  }
}
