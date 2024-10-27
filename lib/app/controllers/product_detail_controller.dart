import 'package:antarkanma/app/data/models/product_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProductDetailController extends GetxController {
  var product = ProductModel(
    id: null,
    name: 'Unknown Product',
    description: 'No description available',
    imageUrls: [], // Array kosong untuk imageUrls
    price: 0.0,
    tags: null,
    merchant: null,
    category: null,
    createdAt: null,
    updatedAt: null,
  ).obs;

  // Getter untuk mendapatkan image yang akan ditampilkan
  String get displayImage {
    if (product.value.imageUrls != null && product.value.imageUrls.isNotEmpty) {
      return product.value.imageUrls[0];
    }
    return 'assets/image_shoes.png'; // Return placeholder image path
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      product.value = Get.arguments as ProductModel;
    }
  }
}
