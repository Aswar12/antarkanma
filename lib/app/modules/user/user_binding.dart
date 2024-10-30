// lib/app/modules/user/bindings/user_binding.dart

import 'package:antarkanma/app/controllers/cart_controller.dart';
import 'package:antarkanma/app/controllers/homepage_controller.dart';
import 'package:antarkanma/app/controllers/product_detail_controller.dart';
import 'package:antarkanma/app/controllers/user_main_controller.dart';
import 'package:get/get.dart';
import 'package:antarkanma/app/controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    // Main Controllers
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<UserMainController>(() => UserMainController());
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController(), permanent: true);
    }
    // Inject HomePageController with UserController dependency
    Get.lazyPut<HomePageController>(() => HomePageController(Get.find()));
    Get.lazyPut<ProductDetailController>(() => ProductDetailController());
    // Feature Controllers (uncomment if needed)
    // Get.lazyPut<ProfileController>(() => ProfileController());
    // Get.lazyPut<ChatController>(() => ChatController());
    // Get.lazyPut<OrderController>(() => OrderController());
  }
}
