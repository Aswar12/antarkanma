// lib/app/services/storage_service.dart

import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:crypto/crypto.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();

  StorageService._();

  final _storage = GetStorage();

  // Keys
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  static const String _merchantKey = 'merchant';
  static const String _rememberMeKey = 'remember_me';
  static const String _savedCredentialsKey = 'saved_credentials';

  // Simple encryption key
  static const String _secretKey = 'your_secret_key_here';

  // Enkripsi sederhana
  String _encrypt(String text) {
    final key = utf8.encode(_secretKey);
    final bytes = utf8.encode(text);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);
    final encrypted = base64Encode(bytes);
    return '$encrypted.${digest.toString()}';
  }

  // Dekripsi sederhana
  String? _decrypt(String? encryptedText) {
    try {
      if (encryptedText == null) return null;

      final parts = encryptedText.split('.');
      if (parts.length != 2) return null;

      final encrypted = parts[0];
      final hash = parts[1];

      final decrypted = base64Decode(encrypted);
      final text = utf8.decode(decrypted);

      // Verify hash
      final key = utf8.encode(_secretKey);
      final hmac = Hmac(sha256, key);
      final digest = hmac.convert(utf8.encode(text));

      if (digest.toString() != hash) return null;

      return text;
    } catch (e) {
      print('Decryption error: $e');
      return null;
    }
  }

  // Token Methods
  Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  String? getToken() {
    return _storage.read(_tokenKey);
  }

  // User Methods
  Future<void> saveUser(Map<String, dynamic> userData) async {
    await _storage.write(_userKey, userData);
  }

  Map<String, dynamic>? getUser() {
    return _storage.read(_userKey);
  }

  // Remember Me Methods
  Future<void> saveRememberMe(bool value) async {
    await _storage.write(_rememberMeKey, value);
  }

  bool getRememberMe() {
    return _storage.read(_rememberMeKey) ?? false;
  }

  // Saved Credentials Methods
  Future<void> saveCredentials(String identifier, String password) async {
    try {
      final credentials = {
        'identifier': _encrypt(identifier),
        'password': _encrypt(password),
      };
      await _storage.write(_savedCredentialsKey, credentials);
      print('Credentials saved successfully');
    } catch (e) {
      print('Error saving credentials: $e');
      rethrow;
    }
  }

  Map<String, String>? getSavedCredentials() {
    try {
      final encryptedData = _storage.read(_savedCredentialsKey);
      if (encryptedData == null) return null;

      final decryptedIdentifier = _decrypt(encryptedData['identifier']);
      final decryptedPassword = _decrypt(encryptedData['password']);

      if (decryptedIdentifier == null || decryptedPassword == null) {
        clearCredentials();
        return null;
      }

      return {
        'identifier': decryptedIdentifier,
        'password': decryptedPassword,
      };
    } catch (e) {
      print('Error getting saved credentials: $e');
      clearCredentials();
      return null;
    }
  }

  // Auto Login Methods
  Future<void> setupAutoLogin({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      if (rememberMe) {
        await saveRememberMe(true);
        await saveCredentials(identifier, password);
      } else {
        await clearAutoLogin();
      }
    } catch (e) {
      print('Error setting up auto login: $e');
      await clearAutoLogin();
    }
  }

  bool canAutoLogin() {
    final rememberMe = getRememberMe();
    final hasCredentials = getSavedCredentials() != null;
    print(
        'Can auto login: RememberMe=$rememberMe, HasCredentials=$hasCredentials');
    return rememberMe && hasCredentials;
  }

  Future<void> clearAutoLogin() async {
    await clearCredentials();
  }

  Future<void> clearCredentials() async {
    await _storage.remove(_savedCredentialsKey);
    await _storage.remove(_rememberMeKey);
  }

  // Clear Methods
  Future<void> clearAuth() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_userKey);
    await _storage.remove(_merchantKey);
  }

  Future<void> clearAll() async {
    await _storage.erase();
  }

  // Debug Methods
  void printStorageState() {
    print('Remember Me: ${getRememberMe()}');
    print('Has Credentials: ${getSavedCredentials() != null}');
    print('Has Token: ${getToken() != null}');
    print('Has User: ${getUser() != null}');
  }
}
