import 'package:antarkanma/app/data/models/product_model.dart';
import 'package:antarkanma/app/widgets/custom_snackbar.dart';
import 'package:antarkanma/theme.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProductDetailController extends GetxController {
  final RxInt currentImageIndex = RxInt(0); // Inisialisasi
  var product = ProductModel(
    id: null,
    name: 'Unknown Product',
    description: 'No description available',
    imageUrls: [], // Array kosong untuk imageUrls
    price: 0.0,
    status: null,
    merchant: null,
    category: null,
    createdAt: null,
    updatedAt: null,
  ).obs;

  final quantity = 1.obs;

  // Method to increment quantity
  void incrementQuantity() {
    // You might want to add a maximum limit
    if (quantity.value < 99) {
      // Example max limit
      quantity.value++;
    } else {
      showCustomSnackbar(
        title: 'Maksimal Mi pesananta',
        message: 'Tidak bisaki kalau lebih 50',
        backgroundColor: logoColorSecondary,
        snackPosition: SnackPosition.BOTTOM,
        isError: true,
      );
    }
  }

  // Method to decrement quantity
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // Reset quantity when leaving the page
  @override
  void onClose() {
    quantity.value = 1;
    super.onClose();
  }

  // Getter untuk mendapatkan image yang akan ditampilkan
  String get displayImage {
    if (product.value.imageUrls != null && product.value.imageUrls.isNotEmpty) {
      return product.value.imageUrls[0];
    }
    return 'assets/image_shoes.png'; // Return placeholder image path
  }

  void updateImageIndex(
    int index,
  ) {
    currentImageIndex.value = index;
  }

  void setProduct(ProductModel newProduct) {
    product.value = newProduct;
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      product.value = Get.arguments as ProductModel;
    }
  }
}
