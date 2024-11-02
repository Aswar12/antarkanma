import 'package:get/get.dart';
import 'package:antarkanma/app/data/models/user_location_model.dart';
import 'package:antarkanma/app/services/user_location_service.dart';
import 'package:antarkanma/app/widgets/custom_snackbar.dart';

class UserLocationController extends GetxController {
  final UserLocationService _locationService = Get.find<UserLocationService>();
  UserLocationController({required UserLocationService locationService});
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  List<UserLocationModel> get addresses => _locationService.userLocations;
  UserLocationModel? get defaultAddress =>
      _locationService.defaultLocation.value;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _locationService.loadUserLocations();
    } catch (e) {
      errorMessage.value = 'Gagal memuat alamat: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addAddress(UserLocationModel address) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _locationService.addUserLocation(address);
      if (!result) {
        errorMessage.value = 'Gagal menambah alamat';
      }
      return result;
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateAddress(UserLocationModel address) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _locationService.updateUserLocation(address);
      if (!result) {
        errorMessage.value = 'Gagal memperbarui alamat';
      }
      return result;
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteAddress(int addressId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _locationService.deleteUserLocation(addressId);
      if (!result) {
        errorMessage.value = 'Gagal menghapus alamat';
      }
      return result;
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> setDefaultAddress(int addressId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _locationService.setDefaultLocation(addressId);
      if (!result) {
        errorMessage.value = 'Gagal mengatur alamat utama';
      }
      return result;
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  List<UserLocationModel> getLocationsByType(String type) {
    return _locationService.userLocations
        .where((loc) => loc.addressType == type)
        .toList();
  }

  List<UserLocationModel> searchLocations(String keyword) {
    return _locationService.userLocations.search(keyword);
  }

  void syncLocations() {
    _locationService.syncLocations();
  }

  void clearLocalData() {
    _locationService.clearLocalData();
  }

  bool hasLocalData() {
    return _locationService.hasLocalData();
  }

  UserLocationModel? getLocationById(int id) {
    return _locationService.getLocationById(id);
  }
}
