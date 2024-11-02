import 'package:get/get.dart';
import 'package:antarkanma/app/data/models/user_location_model.dart';
import 'package:antarkanma/app/data/providers/user_location_provider.dart';
import 'package:antarkanma/app/services/auth_service.dart';
import 'package:antarkanma/app/services/storage_service.dart';
import 'package:antarkanma/app/widgets/custom_snackbar.dart';

class UserLocationService extends GetxService {
  final StorageService _storageService = StorageService.instance;
  final UserLocationProvider _userLocationProvider = UserLocationProvider();
  final AuthService _authService = Get.find<AuthService>();

  final RxList<UserLocationModel> userLocations = <UserLocationModel>[].obs;
  final Rx<UserLocationModel?> defaultLocation = Rx<UserLocationModel?>(null);

  static const String _userLocationsKey = 'user_locations';
  static const String _defaultLocationKey = 'default_location';

  @override
  void onInit() {
    super.onInit();
    loadUserLocationsFromLocal();
    loadUserLocations();
  }

  void loadUserLocationsFromLocal() {
    final localLocations = _storageService.getList(_userLocationsKey);
    if (localLocations != null) {
      userLocations.value = localLocations
          .map((json) => UserLocationModel.fromJson(json))
          .toList();
    }

    final localDefaultLocation = _storageService.getMap(_defaultLocationKey);
    if (localDefaultLocation != null) {
      defaultLocation.value = UserLocationModel.fromJson(localDefaultLocation);
    }
  }

  Future<void> loadUserLocations() async {
    try {
      final token = _authService.getToken();
      if (token == null) {
        showCustomSnackbar(
            title: 'Error', message: 'Token tidak valid', isError: true);
        return;
      }

      final response = await _userLocationProvider.getUserLocations(token);
      if (response.statusCode == 200) {
        final List<dynamic> locationsData = response.data['data'];
        userLocations.value = locationsData
            .map((data) => UserLocationModel.fromJson(data))
            .toList();
        updateDefaultLocation();
        saveLocationsToLocal();
      } else {
        showCustomSnackbar(
            title: 'Error',
            message: 'Gagal memuat lokasi pengguna',
            isError: true);
      }
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Gagal memuat lokasi: ${e.toString()}',
          isError: true);
    }
  }

  void updateDefaultLocation() {
    defaultLocation.value =
        userLocations.firstWhereOrNull((loc) => loc.isDefault);
    if (defaultLocation.value != null) {
      _storageService.saveMap(
          _defaultLocationKey, defaultLocation.value!.toJson());
    } else {
      _storageService.remove(_defaultLocationKey);
    }
  }

  void saveLocationsToLocal() {
    _storageService.saveList(
        _userLocationsKey, userLocations.map((loc) => loc.toJson()).toList());
  }

  Future<bool> addUserLocation(UserLocationModel location) async {
    try {
      final token = _authService.getToken();
      if (token == null) {
        showCustomSnackbar(
            title: 'Error', message: 'Token tidak valid', isError: true);
        return false;
      }

      final response =
          await _userLocationProvider.addUserLocation(token, location.toJson());
      if (response.statusCode == 200) {
        final newLocation = UserLocationModel.fromJson(response.data['data']);
        userLocations.add(newLocation);
        if (newLocation.isDefault) {
          updateDefaultLocation();
        }
        saveLocationsToLocal();
        showCustomSnackbar(
            title: 'Sukses', message: 'Lokasi berhasil ditambahkan');
        return true;
      }

      showCustomSnackbar(
          title: 'Error',
          message: response.data['message'] ?? 'Gagal menambahkan lokasi',
          isError: true);
      return false;
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Gagal menambahkan lokasi: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  Future<bool> updateUserLocation(UserLocationModel location) async {
    try {
      final token = _authService.getToken();
      if (token == null) {
        showCustomSnackbar(
            title: 'Error', message: 'Token tidak valid', isError: true);
        return false;
      }

      final response = await _userLocationProvider.updateUserLocation(
          token, location.id!, location.toJson());
      if (response.statusCode == 200) {
        final updatedLocation =
            UserLocationModel.fromJson(response.data['data']);
        final index =
            userLocations.indexWhere((loc) => loc.id == updatedLocation.id);
        if (index != -1) {
          userLocations[index] = updatedLocation;
          if (updatedLocation.isDefault) {
            updateDefaultLocation();
          }
        }
        saveLocationsToLocal();
        showCustomSnackbar(
            title: 'Sukses', message: 'Lokasi berhasil diperbarui');
        return true;
      }

      showCustomSnackbar(
          title: 'Error',
          message: response.data['message'] ?? 'Gagal memperbarui lokasi',
          isError: true);
      return false;
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Gagal memperbarui lokasi: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  Future<bool> deleteUserLocation(int locationId) async {
    try {
      final token = _authService.getToken();
      if (token == null) {
        showCustomSnackbar(
            title: 'Error', message: 'Token tidak valid', isError: true);
        return false;
      }

      final response =
          await _userLocationProvider.deleteUserLocation(token, locationId);
      if (response.statusCode == 200) {
        userLocations.removeWhere((loc) => loc.id == locationId);
        updateDefaultLocation();
        saveLocationsToLocal();
        showCustomSnackbar(title: 'Sukses', message: 'Lokasi berhasil dihapus');
        return true;
      }

      showCustomSnackbar(
          title: 'Error',
          message: response.data['message'] ?? 'Gagal menghapus lokasi',
          isError: true);
      return false;
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Gagal menghapus lokasi: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  Future<bool> setDefaultLocation(int locationId) async {
    try {
      final token = _authService.getToken();
      if (token == null) {
        showCustomSnackbar(
            title: 'Error', message: 'Token tidak valid', isError: true);
        return false;
      }

      final response =
          await _userLocationProvider.setDefaultLocation(token, locationId);
      if (response.statusCode == 200) {
        for (var loc in userLocations) {
          loc.isDefault = loc.id == locationId;
        }
        updateDefaultLocation();
        saveLocationsToLocal();
        showCustomSnackbar(
            title: 'Sukses', message: 'Lokasi default berhasil diubah');
        return true;
      }

      showCustomSnackbar(
          title: 'Error',
          message: response.data['message'] ?? 'Gagal mengubah lokasi default',
          isError: true);
      return false;
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Gagal mengubah lokasi default: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  // Getter Methods
  List<UserLocationModel> get activeLocations =>
      userLocations.where((loc) => loc.isActive).toList();
  UserLocationModel? get getDefaultLocation => defaultLocation.value;

  // Method untuk sinkronisasi data lokal dengan server
  Future<void> syncLocations() async {
    await loadUserLocations();
  }

  // Method untuk membersihkan data lokal
  void clearLocalData() {
    _storageService.remove(_userLocationsKey);
    _storageService.remove(_defaultLocationKey);
    userLocations.clear();
    defaultLocation.value = null;
  }

  // Method untuk memeriksa apakah ada data lokal
  bool hasLocalData() {
    return _storageService.getList(_userLocationsKey) != null;
  }

  // Method untuk mendapatkan lokasi berdasarkan ID
  UserLocationModel? getLocationById(int id) {
    return userLocations.firstWhereOrNull((loc) => loc.id == id);
  }

  @override
  void onClose() {
    userLocations.close();
    defaultLocation.close();
    super.onClose();
  }
}
