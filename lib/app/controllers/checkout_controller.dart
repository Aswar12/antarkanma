import 'package:get/get.dart';
import 'package:antarkanma/app/data/models/order_item_model.dart';
import 'package:antarkanma/app/data/models/cart_item_model.dart';
import 'package:antarkanma/app/controllers/cart_controller.dart';
import 'package:antarkanma/app/data/models/user_location_model.dart';

class CheckoutController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final orderItems = <OrderItemModel>[].obs;
  final selectedLocation = Rx<UserLocationModel?>(null);
  final selectedPaymentMethod = Rx<String?>(null);
  final subtotal = 0.0.obs;
  final deliveryFee = 0.0.obs;
  final total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCheckout();
  }

  void _initializeCheckout() {
    try {
      final args = Get.arguments;
      if (args != null && args['merchantItems'] != null) {
        final merchantItems =
            args['merchantItems'] as Map<int, List<CartItemModel>>;

        // Convert merchant items ke order items
        for (var entry in merchantItems.entries) {
          final items = entry.value;
          for (var cartItem in items) {
            final orderItem = OrderItemModel(
              orderId: '', // Akan diisi setelah order dibuat
              product: cartItem.product,
              merchant: cartItem.merchant,
              quantity: cartItem.quantity,
              price: cartItem.price,
              selectedVariantId: cartItem.selectedVariantId?.toString(),
              status: 'PENDING',
              createdAt: DateTime.now(),
            );
            orderItems.add(orderItem);
          }
        }
        _calculateTotals();
      }
    } catch (e) {
      print('Error initializing checkout: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat data checkout',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _calculateTotals() {
    // Hitung subtotal
    subtotal.value = orderItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    // Hitung biaya pengiriman (implementasi sederhana)
    deliveryFee.value = orderItems.isEmpty ? 0.0 : 10000.0;

    // Hitung total
    total.value = subtotal.value + deliveryFee.value;
  }

  // Getter untuk mengecek apakah checkout bisa dilakukan
  bool get canCheckout {
    return orderItems.isNotEmpty &&
        selectedLocation.value != null &&
        selectedPaymentMethod.value != null;
  }

  // Method untuk memproses checkout
  Future<void> processCheckout() async {
    if (!canCheckout) {
      Get.snackbar(
        'Peringatan',
        'Mohon lengkapi semua data checkout',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // TODO: Implementasi proses checkout ke backend
      // 1. Buat order baru
      // 2. Simpan order items
      // 3. Buat transaksi
      // 4. Proses pembayaran

      // Simulasi delay proses
      await Future.delayed(const Duration(seconds: 2));

      // Clear cart setelah checkout berhasil
      Get.find<CartController>().clearCart();

      // Navigate ke halaman sukses
      Get.offNamed('/checkout-success', arguments: {
        'orderItems': orderItems,
        'total': total.value,
        'deliveryAddress': selectedLocation.value,
        'paymentMethod': selectedPaymentMethod.value,
      });
    } catch (e) {
      print('Error processing checkout: $e');
      Get.snackbar(
        'Error',
        'Gagal memproses checkout: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk mengubah lokasi pengiriman
  void setDeliveryLocation(UserLocationModel location) {
    selectedLocation.value = location;
    _calculateTotals(); // Recalculate totals karena biaya pengiriman mungkin berubah
  }

  // Method untuk mengubah metode pembayaran
  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  @override
  void onClose() {
    // Clean up jika diperlukan
    super.onClose();
  }
}
