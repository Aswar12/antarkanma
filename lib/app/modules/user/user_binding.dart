import 'package:antarkanma/app/controllers/auth_controller.dart';
import 'package:antarkanma/app/modules/user/controllers/edit_profile_controller.dart';
import 'package:antarkanma/app/controllers/cart_controller.dart';
import 'package:antarkanma/app/services/category_service.dart';
import 'package:antarkanma/app/data/providers/product_provider.dart';
import 'package:antarkanma/app/data/repositories/review_repository.dart';
import 'package:antarkanma/app/controllers/checkout_controller.dart';
import 'package:antarkanma/app/controllers/homepage_controller.dart';
import 'package:antarkanma/app/controllers/map_picker_controller.dart';
import 'package:antarkanma/app/controllers/order_controller.dart';
import 'package:antarkanma/app/controllers/product_detail_controller.dart';
import 'package:antarkanma/app/controllers/user_location_controller.dart';
import 'package:antarkanma/app/controllers/user_main_controller.dart';
import 'package:antarkanma/app/services/transaction_service.dart';
import 'package:antarkanma/app/services/user_location_service.dart';
import 'package:antarkanma/app/services/product_service.dart';
import 'package:antarkanma/app/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:antarkanma/app/controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    print('Initializing UserBinding dependencies...');
    
    // Required Services for HomePageController
    if (!Get.isRegistered<AuthService>()) {
      print('Initializing AuthService...');
      Get.put(AuthService(), permanent: true);
    }
    
    if (!Get.isRegistered<CategoryService>()) {
      print('Initializing CategoryService...');
      Get.put(CategoryService(), permanent: true);
    }
    
    if (!Get.isRegistered<ProductService>()) {
      print('Initializing ProductService...');
      Get.put(ProductService(), permanent: true);
    }

    // Main Controllers
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<UserMainController>(() => UserMainController());

    // Cart Controller (permanent instance)
    if (!Get.isRegistered<CartController>()) {
      print('Initializing CartController...');
      Get.put(CartController(), permanent: true);
    }

    // Providers and Repositories
    print('Initializing ProductProvider...');
    Get.lazyPut(() => ProductProvider(), fenix: true);
    print('Initializing ReviewRepository...');
    Get.lazyPut(() => ReviewRepository(provider: Get.find()), fenix: true);

    // Initialize HomePageController after its dependencies
    print('Initializing HomePageController...');
    Get.put(HomePageController(), permanent: true);

    // Product Detail Controller
    print('Initializing ProductDetailController...');
    Get.lazyPut<ProductDetailController>(
      () => ProductDetailController(reviewRepository: Get.find()),
      fenix: true,
    );

    // Location Related Dependencies
    print('Initializing Location Services...');
    Get.lazyPut<UserLocationService>(
      () => UserLocationService(),
      fenix: true,
    );
    Get.lazyPut<MapPickerController>(() => MapPickerController());
    Get.lazyPut<UserLocationController>(
      () => UserLocationController(
        locationService: Get.find<UserLocationService>(),
      ),
      fenix: true,
    );

    // Transaction and Order Related Dependencies
    print('Initializing Transaction Services...');
    Get.lazyPut(() => TransactionService(), fenix: true);
    Get.lazyPut(() => OrderController(), fenix: true);

    Get.lazyPut<CheckoutController>(
      () => CheckoutController(
        userLocationController: Get.find<UserLocationController>(),
        authController: Get.find<AuthController>(),
      ),
    );

    // Additional Feature Controllers
    _initializeFeatureControllers();
    
    print('UserBinding dependencies initialization complete');
  }

  void _initializeFeatureControllers() {
    print('Initializing Feature Controllers...');
    Get.lazyPut(() => EditProfileController(), fenix: true);
  }
}
