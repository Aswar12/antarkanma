// ignore_for_file: constant_identifier_names

import 'package:antarkanma/app/modules/courier/views/courier_main_page.dart';
import 'package:antarkanma/app/modules/merchant/views/merchant_main_page.dart';
import 'package:antarkanma/app/modules/user/views/chat_page.dart';
import 'package:antarkanma/app/modules/user/views/user_main_page.dart';
import 'package:get/get.dart';
import 'package:antarkanma/app/modules/splash/views/splash_page.dart';
import 'package:antarkanma/app/modules/auth/views/sign_in_page.dart';
import 'package:antarkanma/app/modules/auth/views/sign_up_page.dart';

import 'package:antarkanma/app/modules/user/views/profile_page.dart';
import 'package:antarkanma/app/modules/auth/auth_binding.dart';
import 'package:antarkanma/app/modules/user/user_binding.dart';

abstract class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
  static const cart = '/cart';
  static const order = '/order';
  static const orderHistory = '/order-history';
  static const productList = '/product-list';
  static const merchantHome = '/merchant-home';
  static const courierHome = '/courier-home';
  static const chat = '/chat';
}

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: Routes.login,
      page: () => SignInPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => SignUpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => UserMainPage(),
      binding: UserBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfilePage(),
      binding: UserBinding(),
    ),
    GetPage(
      name: Routes.chat,
      page: () => const ChatPage(),
      binding: UserBinding(),
    ),
    GetPage(
      name: Routes.merchantHome,
      page: () => const MerchantMainPage(), // Menambahkan MerchantMainPage
      binding: UserBinding(), // Anda bisa menggunakan binding yang sesuai
    ),
    GetPage(
      name: Routes.courierHome,
      page: () => const CourierMainPage(), // Menambahkan CourierMainPage
      binding: UserBinding(), // Anda bisa menggunakan binding yang sesuai
    ),
  ];
}
