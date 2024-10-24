import 'package:antarkanma/app/data/providers/auth_provider.dart';
import 'package:antarkanma/app/utils/validators.dart';
import 'package:antarkanma/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import './storage_service.dart';
import '../routes/app_pages.dart';

class AuthService extends GetxService {
  final StorageService _storageService = StorageService.instance;
  final AuthProvider _authProvider = AuthProvider();

  final RxBool isLoggedIn = false.obs;
  final Rx<Map<String, dynamic>> currentUser = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    final token = _storageService.getToken();
    final userData = _storageService.getUser();

    if (token != null && userData != null) {
      isLoggedIn.value = true;
      currentUser.value = userData;
      _redirectBasedOnRole();
    } else {
      isLoggedIn.value = false;
      currentUser.value = {};
    }
  }

  Future<bool> refreshToken() async {
    try {
      final currentToken = _storageService.getToken();
      if (currentToken == null) {
        return false;
      }

      final response = await _authProvider.refreshToken(currentToken);
      if (response.statusCode == 200) {
        final newToken = response.data['data']['access_token'];
        await _storageService.saveToken(newToken);
        return true;
      }
      return false;
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }

  Future<void> checkAndRefreshToken() async {
    // Implementasi logika untuk memeriksa apakah token perlu diperbarui
    // Misalnya, berdasarkan waktu kedaluwarsa token
    bool needsRefresh = true; // Ganti dengan logika yang sesuai

    if (needsRefresh) {
      bool refreshSuccess = await refreshToken();
      if (!refreshSuccess) {
        // Token tidak dapat diperbarui, mungkin perlu logout
        await logout();
      }
    }
  }

  Future<bool> login(String identifier, String password) async {
    try {
      final validationError = Validators.validateIdentifier(identifier);
      if (validationError != null) {
        showCustomSnackbar(
            title: 'Error', message: validationError, isError: true);
        return false;
      }

      final response = await _authProvider.login(identifier, password);
      if (response.statusCode != 200) {
        showCustomSnackbar(
            title: 'Login Gagal',
            message: response.data['meta']['message'] ?? 'Terjadi kesalahan',
            isError: true);
        return false;
      }

      final userData = response.data['data']['user'];
      final token = response.data['data']['access_token'];

      if (token != null) {
        await _storageService.saveToken(token);
        await _storageService.saveUser(userData);
        currentUser.value = userData;
        isLoggedIn.value = true;
        _redirectBasedOnRole();
        return true;
      } else {
        showCustomSnackbar(
            title: 'Error', message: 'Token tidak valid.', isError: true);
        return false;
      }
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Gagal login: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  Future<bool> register(String name, String email, String phoneNumber,
      String password, String confirmPassword) async {
    try {
      if ([name, email, phoneNumber, password].any((field) => field.isEmpty)) {
        showCustomSnackbar(
            title: 'Error', message: 'Semua field harus diisi.', isError: true);
        return false;
      }

      final userData = {
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'password_confirmation': confirmPassword,
      };

      final response = await _authProvider.register(userData);
      if (response.statusCode == 200) {
        final userData = response.data['data']['user'];
        final token = response.data['data']['access_token'];
        if (token != null && userData != null) {
          await _storageService.saveToken(token);
          await _storageService.saveUser(userData);
          currentUser.value = userData;
          isLoggedIn.value = true;
          _redirectBasedOnRole();
          return true;
        } else {
          showCustomSnackbar(
              title: 'Error',
              message: 'Data login tidak valid.',
              isError: true);
          return false;
        }
      }

      showCustomSnackbar(
          title: 'Registrasi Gagal',
          message: response.data['meta']['message'] ?? 'Registrasi gagal',
          isError: true);
      return false;
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Gagal registrasi: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  void _redirectBasedOnRole() {
    String userRole = currentUser.value['roles'] ?? '';
    switch (userRole) {
      case 'USER':
        Get.offAllNamed(Routes.home);
        break;
      case 'MERCHANT':
        Get.offAllNamed(Routes.merchantHome);
        break;
      case 'COURIER':
        Get.offAllNamed(Routes.courierHome);
        break;
      default:
        Get.offAllNamed(Routes.login);
    }
  }

  Future<bool> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      if (newPassword.length < 6) {
        showCustomSnackbar(
            title: 'Error',
            message: 'Password baru harus memiliki minimal 6 karakter',
            isError: true);
        return false;
      }

      if (newPassword != confirmPassword) {
        showCustomSnackbar(
            title: 'Error',
            message: 'Password baru tidak cocok',
            isError: true);
        return false;
      }

      final response = await _authProvider.changePassword(token, {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      });

      if (response.statusCode == 200) {
        showCustomSnackbar(
            title: 'Sukses', message: 'Password berhasil diubah');
        return true;
      }

      showCustomSnackbar(
          title: 'Error',
          message: response.data['message'] ?? 'Gagal mengganti password',
          isError: true);
      return false;
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Gagal mengganti password: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  Future<bool> deleteAccount(String token) async {
    try {
      final response = await _authProvider.deleteAccount(token);
      if (response.statusCode == 200) {
        showCustomSnackbar(title: 'Sukses', message: 'Akun berhasil dihapus');
        await _clearAuthData();
        return true;
      }

      showCustomSnackbar(
          title: 'Error',
          message: response.data['message'] ?? 'Gagal menghapus akun',
          isError: true);
      return false;
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Gagal menghapus akun: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authProvider.logout(_storageService.getToken()!);
    } finally {
      await _clearAuthData();
      Get.offAllNamed(Routes.login);
    }
  }

  Future<void> _clearAuthData() async {
    await _storageService.clearAuth();
    isLoggedIn.value = false;
    currentUser.value = {};
  }

  String? getToken() => _storageService.getToken();

  Map<String, dynamic>? getUser() => currentUser.value;

  String get userName => currentUser.value['name'] ?? '';

  String get userEmail => currentUser.value['email'] ?? '';
  String get userPhone => currentUser.value['phone_number'] ?? '';

  String get userRole => currentUser.value['roles'] ?? '';

  bool get isMerchant => userRole == 'MERCHANT';

  bool get isCourier => userRole == 'COURIER';

  bool get isUser => userRole == 'USER';

  int? get userId => currentUser.value['id'];

  Future<bool> updateProfile({
    required String token,
    required String name,
    required String email,
    // Tambahkan parameter lain sesuai kebutuhan
  }) async {
    try {
      final response = await _authProvider.updateProfile(token, {
        'name': name,
        'email': email,
        // Tambahkan data lain yang ingin diperbarui
      });

      if (response.statusCode == 200) {
        showCustomSnackbar(
            title: 'Sukses', message: 'Profil berhasil diperbarui');
        // Perbarui data pengguna di penyimpanan lokal
        final updatedUser = currentUser.value;
        updatedUser['name'] = name;
        updatedUser['email'] = email;
        await _storageService.saveUser(updatedUser);
        currentUser.value = updatedUser;
        return true;
      }

      showCustomSnackbar(
          title: 'Error',
          message: response.data['message'] ?? 'Gagal memperbarui profil',
          isError: true);
      return false;
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Gagal memperbarui profil: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  void handleAuthError(dynamic error) {
    if (error.toString().contains('401')) {
      _clearAuthData();
      showCustomSnackbar(
          title: 'Error',
          message: 'Sesi Anda telah berakhir. Silakan login kembali.',
          isError: true);
      Get.offAllNamed(Routes.login);
    }
  }

  // Method untuk dispose
  @override
  void onClose() {
    currentUser.close();
    super.onClose();
  }
}
