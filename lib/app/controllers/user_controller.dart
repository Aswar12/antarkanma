// lib/app/controllers/user_controller.dart

import 'package:get/get.dart';

import '../services/storage_service.dart';

class UserController extends GetxController {
  final StorageService _storage = StorageService.instance;

  final Rx<Map<String, dynamic>> user = Rx<Map<String, dynamic>>({});
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
  }

  void loadUserFromStorage() {
    final userData = _storage.getUser();
    if (userData != null) {
      user.value = userData;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;
      error.value = '';

      if (response.status.isOk) {
        user.value = response.body;
        await _storage.saveUser(response.body);
        Get.snackbar('Success', 'Profile updated successfully');
      } else {
        error.value = 'Failed to update profile';
        Get.snackbar('Error', 'Failed to update profile');
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'An error occurred while updating profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _productService.getUserProfile();

      if (response.status.isOk) {
        user.value = response.body;
        await _storage.saveUser(response.body);
      } else {
        error.value = 'Failed to fetch user profile';
        Get.snackbar('Error', 'Failed to fetch user profile');
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'An error occurred while fetching profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      error.value = '';

      await _productService.logout();
      await _storage.clearAuth();

      user.value = {};
      Get.offAllNamed('/login'); // Navigate to login screen
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'An error occurred while logging out');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper methods
  bool get isLoggedIn => _storage.isLoggedIn();

  String? get token => _storage.getToken();

  String get userName => user.value['name'] ?? '';

  String get userEmail => user.value['email'] ?? '';

  String get userRole => user.value['role'] ?? '';

  bool get isMerchant => userRole == 'MERCHANT';

  bool get isCourier => userRole == 'COURIER';

  int? get userId => user.value['id'];

  String get phoneNumber => user.value['phone_number'] ?? '';

  Map<String, dynamic>? get merchant => _storage.getMerchant();
}
