import 'package:dio/dio.dart';
import 'package:antarkanma/config.dart';

class UserLocationProvider {
  final Dio _dio = Dio();
  final String baseUrl = Config.baseUrl;

  UserLocationProvider() {
    _setupBaseOptions();
    _setupInterceptors();
  }

  void _setupBaseOptions() {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status! < 500,
    );
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers.addAll({
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          });
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          _handleError(error);
          return handler.next(error);
        },
      ),
    );
  }

  void _handleError(DioException error) {
    String message;
    switch (error.response?.statusCode) {
      case 401:
        message = 'Unauthorized access. Please log in again.';
        break;
      case 422:
        final errors = error.response?.data['errors'];
        message = errors.toString();
        break;
      default:
        message = error.response?.data['message'] ?? 'An error occurred';
    }
    throw Exception(message);
  }

  // Get all user locations
  Future<Response> getUserLocations(String token) async {
    try {
      return await _dio.get(
        '/user/locations',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      throw Exception('Failed to get user locations: $e');
    }
  }

  // Get single user location
  Future<Response> getUserLocation(String token, int locationId) async {
    try {
      return await _dio.get(
        '/user/locations/$locationId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      throw Exception('Failed to get user location: $e');
    }
  }

  // Add new user location
  Future<Response> addUserLocation(
      String token, Map<String, dynamic> data) async {
    try {
      return await _dio.post(
        '/user-locations',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: data,
      );
    } catch (e) {
      throw Exception('Failed to add user location: $e');
    }
  }

  // Update user location
  Future<Response> updateUserLocation(
      String token, int locationId, Map<String, dynamic> data) async {
    try {
      return await _dio.put(
        '/user-locations/$locationId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: data,
      );
    } catch (e) {
      throw Exception('Failed to update user location: $e');
    }
  }

  // Delete user location
  Future<Response> deleteUserLocation(String token, int locationId) async {
    try {
      return await _dio.delete(
        '/user-locations/$locationId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      throw Exception('Failed to delete user location: $e');
    }
  }

  // Set default location
  Future<Response> setDefaultLocation(String token, int locationId) async {
    try {
      return await _dio.put(
        '/user-locations/$locationId/set-default',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      throw Exception('Failed to set default location: $e');
    }
  }

  // Get nearby locations (optional)
  Future<Response> getNearbyLocations(
      String token, double latitude, double longitude,
      {double radius = 5000}) async {
    try {
      return await _dio.get(
        '/user-locations/nearby',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
        },
      );
    } catch (e) {
      throw Exception('Failed to get nearby locations: $e');
    }
  }

  // Bulk delete locations (optional)
  Future<Response> bulkDeleteLocations(
      String token, List<int> locationIds) async {
    try {
      return await _dio.delete(
        '/user/locations/bulk-delete',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {'location_ids': locationIds},
      );
    } catch (e) {
      throw Exception('Failed to bulk delete locations: $e');
    }
  }

  // Search locations by keyword (optional)
  Future<Response> searchLocations(String token, String keyword) async {
    try {
      return await _dio.get(
        '/user-locations/search',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        queryParameters: {'keyword': keyword},
      );
    } catch (e) {
      throw Exception('Failed to search locations: $e');
    }
  }

  // Validate address (optional)
  Future<Response> validateAddress(
      String token, Map<String, dynamic> data) async {
    try {
      return await _dio.post(
        '/user/locations/validate',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: data,
      );
    } catch (e) {
      throw Exception('Failed to validate address: $e');
    }
  }

  // Get user location statistics (optional)
  Future<Response> getLocationStatistics(String token) async {
    try {
      return await _dio.get(
        '/user/locations/statistics',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      throw Exception('Failed to get location statistics: $e');
    }
  }
}
