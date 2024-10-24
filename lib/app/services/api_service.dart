import 'package:get/get.dart';
import 'storage_service.dart';

class ApiService extends GetConnect {
  final StorageService _storage = StorageService.instance;

  @override
  void onInit() {
    // Base URL configuration
    httpClient.baseUrl = 'http://192.168.213.93:8000/api';

    // Request timeout
    httpClient.timeout = const Duration(seconds: 30);

    // Add default headers
    httpClient.addAuthenticator<dynamic>((request) async {
      final token = _storage.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    // Response handling
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return map;
      if (map is List) return map;
      return map;
    };

    // Error handling
    httpClient.maxAuthRetries = 3;

    super.onInit();
  }

  // Auth Methods
  Future<Response> login(String email, String password) async {
    try {
      final response = await post('/login', {
        'email': email,
        'password': password,
      });

      if (response.status.isOk) {
        final token = response.body['token'];
        await _storage.saveToken(token);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> register(Map<String, dynamic> userData) async {
    try {
      return await post('/register', userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> logout() async {
    try {
      final response = await post('/auth/logout', null);
      await _storage.clearAuth();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // User Methods
  Future<Response> getUserProfile() async {
    try {
      return await get('/users/profile');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      return await put('/users/profile', userData);
    } catch (e) {
      rethrow;
    }
  }

  // Product Methods
  Future<Response> getProducts({int? page, int? limit, String? search}) async {
    try {
      final queryParams = {
        if (page != null) 'page': page.toString(),
        if (limit != null) 'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      return await get('/products', query: queryParams);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getProductDetails(int productId) async {
    try {
      return await get('/products/$productId');
    } catch (e) {
      rethrow;
    }
  }

  // Cart Methods
  Future<Response> getCart() async {
    try {
      return await get('/cart');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addToCart(Map<String, dynamic> cartItem) async {
    try {
      return await post('/cart/items', cartItem);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateCartItem(int itemId, Map<String, dynamic> data) async {
    try {
      return await put('/cart/items/$itemId', data);
    } catch (e) {
      rethrow;
    }
  }
}
