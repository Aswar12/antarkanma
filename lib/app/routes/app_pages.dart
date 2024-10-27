// lib/app/routes/app_pages.dart

import 'package:antarkanma/app/modules/auth/auth_binding.dart';
import 'package:antarkanma/app/modules/auth/views/sign_in_page.dart';
import 'package:antarkanma/app/modules/auth/views/sign_up_page.dart';
import 'package:antarkanma/app/modules/merchant/merchant_binding.dart';
import 'package:antarkanma/app/modules/courier/courier_binding.dart';
import 'package:antarkanma/app/modules/merchant/views/merchant_main_page.dart';
import 'package:antarkanma/app/modules/splash/views/splash_page.dart';
import 'package:antarkanma/app/modules/user/user_binding.dart';
import 'package:antarkanma/app/modules/user/views/chat_page.dart';
import 'package:antarkanma/app/modules/user/views/order_page.dart';
import 'package:antarkanma/app/modules/user/views/product_detail_page.dart';
import 'package:antarkanma/app/modules/user/views/profile_page.dart';
import 'package:antarkanma/app/modules/user/views/user_main_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

abstract class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';

  // User routes
  static const home = '/home';
  static const profile = '/home/profile';
  static const chat = '/home/chat';
  static const cart = '/home/cart';
  static const order = '/home/order';
  static const orderHistory = '/home/order-history';
  static const productDetail = '/product-detail';
  // Merchant routes
  static const merchantHome = '/merchant';
  static const merchantProducts = '/merchant/products';
  static const merchantOrders = '/merchant/orders';

  // Courier routes
  static const courierHome = '/courier';
  static const courierDeliveries = '/courier/deliveries';
  static const courierHistory = '/courier/history';
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

    // User Routes
    GetPage(
      name: Routes.home,
      page: () => const UserMainPage(),
      binding: UserBinding(),
      children: [
        GetPage(
          name: '/profile',
          page: () => const ProfilePage(),
        ),
        GetPage(
          name: '/chat',
          page: () => const ChatPage(),
        ),
        GetPage(
          name: '/order',
          page: () => const OrderPage(),
        ),
      ],
    ),

    // Merchant Routes
    // GetPage(
    //   name: Routes.merchantHome,
    //   page: () => const MerchantMainPage(),
    //   binding: MerchantBinding(),
    //   children: [
    //     // Sub-routes untuk merchant jika ada
    //   ],
    // ),

    // Courier Routes
    // GetPage(
    //   name: Routes.courierHome,
    //   page: () => const CourierMainPage(),
    //   binding: CourierBinding(),
    //   children: [
    //     // Sub-routes untuk courier jika ada
    //   ],
    // ),
  ];
}
