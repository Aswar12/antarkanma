import 'package:antarkanma/app/data/models/transaction_model.dart';
import 'package:antarkanma/app/services/order_item_service.dart';
import 'package:antarkanma/app/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:antarkanma/app/data/models/order_item_model.dart';
import 'package:antarkanma/app/data/models/cart_item_model.dart';
import 'package:antarkanma/app/controllers/cart_controller.dart';
import 'package:antarkanma/app/data/models/user_location_model.dart';
import 'package:antarkanma/app/controllers/auth_controller.dart'; // Import AuthController
import 'user_location_controller.dart';

class CheckoutController extends GetxController {
  final UserLocationController userLocationController =
      Get.find<UserLocationController>();
  final AuthController authController =
      Get.find<AuthController>(); // Inisialisasi AuthController
  final isLoading = false.obs;
  final orderItems = <OrderItemModel>[].obs;
  final selectedLocation = Rx<UserLocationModel?>(null);
  final selectedPaymentMethod = Rx<String?>(null);
  final subtotal = 0.0.obs;
  final deliveryFee = 0.0.obs;
  final total = 0.0.obs;

  final List<String> paymentMethods = [
    'COD',
    'Transfer Bank',
    'DANA',
    'OVO',
    'GoPay',
  ];

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  @override
  void onInit() {
    super.onInit();
    selectedLocation.value = userLocationController.defaultAddress;
    _initializeCheckout();
  }

  void loadDefaultLocation() {
    final defaultLocation = userLocationController.defaultAddress;
    selectedLocation.value = defaultLocation; // Set default address
  }

  void _initializeCheckout() {
    try {
      final args = Get.arguments;
      if (args != null && args['merchantItems'] != null) {
        final merchantItems =
            args['merchantItems'] as Map<int, List<CartItemModel>>;

        // Convert merchant items ke order items
        for (var entry in merchantItems.entries) {
          for (var cartItem in entry.value) {
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

    // Hitung biaya pengiriman
    deliveryFee.value = orderItems.isEmpty ? 0.0 : 10000.0;

    // Hitung total
    total.value = subtotal.value + deliveryFee.value;
  }

  // Getter untuk mengecek apakah checkout bisa dilakukan
  bool get canCheckout {
    return orderItems.isNotEmpty &&
        selectedPaymentMethod.value != null &&
        selectedLocation.value != null;
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

      // Ambil userId dari AuthController
      final userId = userLocationController
          .selectedLocation.value?.userId; // Ambil c dar AuthController
      final deliveryLocationId =
          selectedLocation.value?.id; // Ambil ID lokasi pengiriman

      // Buat objek TransactionModel
      final transaction = TransactionModel(
        orderId: '', // Akan diisi setelah order dibuat
        userId: userId.toString(),
        userLocationId: deliveryLocationId.toString(),
        totalPrice: total.value,
        shippingPrice: deliveryFee.value,
        paymentMethod: selectedPaymentMethod.value!,
        status: 'PENDING',
      );

      // Simulasi delay proses
      await Future.delayed(const Duration(seconds: 2));

      // Simpan transaksi ke backend
      final transactionService = Get.find<TransactionService>();
      final isTransactionCreated =
          await transactionService.createTransaction(transaction);

      if (!isTransactionCreated) {
        Get.snackbar('Error', 'Gagal membuat transaksi');
        return;
      }

      // Simpan setiap order item
      final orderItemService = Get.find<OrderItemService>();
      for (var orderItem in orderItems) {
        orderItem.orderId =
            transaction.id.toString(); // Set orderId untuk setiap order item
        final isOrderItemCreated =
            await orderItemService.createOrderItem(orderItem);
        if (!isOrderItemCreated) {
          Get.snackbar(
              'Error', 'Gagal menyimpan order item: ${orderItem.product.name}');
          return;
        }
      }

      // Clear cart setelah checkout berhasil
      Get.find<CartController>().clearCart();

      // Navigate ke halaman sukses
      Get.offNamed('/checkout-success', arguments: {
        'orderItems': orderItems,
        'total': total.value,
        'deliveryAddress': selectedLocation.value,
        'paymentMethod': selectedPaymentMethod.value,
        'userId': userId, // Sertakan userId dalam argumen
        'deliveryLocationId':
            deliveryLocationId, // Sertakan ID lokasi pengiriman
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
  // Misalkan ini adalah variabel untuk menyimpan metode pembayaran

  // Metode untuk mengatur metode pembayaran
  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // Method untuk mengubah lokasi pengiriman
  void setDeliveryLocation(UserLocationModel location) {
    selectedLocation.value = location;
    _calculateTotals(); // Recalculate totals karena biaya pengiriman mungkin berubah
  }

  // Method untuk mengupdate lokasi yang dipilih dari AddressSelectionPage
  void updateSelectedLocation(UserLocationModel location) {
    selectedLocation.value = location;
    _calculateTotals(); // Recalculate totals jika lokasi diubah
    update(); // Memperbarui UI
  }

  @override
  void onClose() {
    // Clean up jika diperlukan
    super.onClose();
  }
}
