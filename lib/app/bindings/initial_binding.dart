// lib/app/bindings/initial_binding.dart

import 'package:get/get.dart';
import 'package:antarkanma/app/controllers/auth_controller.dart';
import 'package:antarkanma/app/controllers/user_controller.dart';

import 'package:antarkanma/app/services/auth_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services

    Get.put(AuthService(), permanent: true);
    // Controllers
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => UserController());
  }
}
