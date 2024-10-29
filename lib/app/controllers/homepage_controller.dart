import 'package:antarkanma/app/data/models/product_model.dart';
import 'package:get/get.dart';
import 'package:antarkanma/app/services/product_service.dart';

class HomePageController extends GetxController {
  var products = <ProductModel>[].obs;
  var isLoading = true.obs;

  final ProductService productService;

  HomePageController(this.productService);

  @override
  void onInit() {
    loadProducts();
    super.onInit();
  }

  void loadProducts() async {
    try {
      isLoading(true); // Mulai loading
      await productService.fetchProducts(); // Tunggu fetchProducts selesai
      products.assignAll(productService.products);
      print(products); // Ambil data dari service
    } catch (e) {
      print('Error loading products: $e');
      // Tambahkan penanganan error, seperti menampilkan snackbar
      Get.snackbar('Error', 'Failed to load products: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false); // Selesai loading
    }
  }
}
