// lib/app/services/storage_service.dart

import 'package:get_storage/get_storage.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();

  StorageService._();

  final _storage = GetStorage();

  // Keys
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  static const String _merchantKey = 'merchant';

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

  // Merchant Methods
  Future<void> saveMerchant(Map<String, dynamic> merchantData) async {
    await _storage.write(_merchantKey, merchantData);
  }

  Map<String, dynamic>? getMerchant() {
    return _storage.read(_merchantKey);
  }

  // Auth Status
  bool isLoggedIn() {
    return getToken() != null;
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
}
