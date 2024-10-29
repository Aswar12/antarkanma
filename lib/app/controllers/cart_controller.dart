import 'package:antarkanma/app/data/models/cart_item_model.dart';
import 'package:antarkanma/app/data/models/product_model.dart';
import 'package:antarkanma/app/data/models/variant_model.dart';
import 'package:antarkanma/app/data/models/merchant_model.dart';
import 'package:antarkanma/app/widgets/custom_snackbar.dart';
import 'package:antarkanma/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final RxMap<int, List<CartItemModel>> merchantItems =
      <int, List<CartItemModel>>{}.obs;

  void addToCart(
    ProductModel product,
    int quantity, {
    VariantModel? selectedVariant,
    required MerchantModel merchant,
  }) {
    if (!merchant.isActive) {
      showCustomSnackbar(
        title: 'Merchant Tidak Aktif',
        message: 'Merchant ini sedang tidak aktif',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final merchantId = merchant.id;
    // Tambahkan pengecekan null
    if (merchantId == null) {
      showCustomSnackbar(
        title: 'Error',
        message: 'ID Merchant tidak valid',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!merchantItems.containsKey(merchantId)) {
      merchantItems[merchantId] = [];
    }

    // Sisa kode tetap sama
    final existingItemIndex = merchantItems[merchantId]!.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedVariant?.id == selectedVariant?.id);

    if (existingItemIndex != -1) {
      final existingItem = merchantItems[merchantId]![existingItemIndex];
      merchantItems[merchantId]![existingItemIndex] = CartItemModel(
        product: existingItem.product,
        quantity: existingItem.quantity + quantity,
        selectedVariant: existingItem.selectedVariant,
        merchant: merchant,
      );
    } else {
      merchantItems[merchantId]!.add(CartItemModel(
        product: product,
        quantity: quantity,
        selectedVariant: selectedVariant,
        merchant: merchant,
      ));
    }

    update();
    showCustomSnackbar(
      title: 'Berhasil',
      message: 'Produk berhasil ditambahkan ke keranjang',
      backgroundColor: logoColorSecondary,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  double get totalPrice {
    double total = 0;
    merchantItems.forEach((merchantId, items) {
      total += getMerchantTotal(merchantId);
    });
    return total;
  }

  void removeFromCart(int merchantId, int index) {
    if (merchantItems.containsKey(merchantId)) {
      merchantItems[merchantId]!.removeAt(index);
      if (merchantItems[merchantId]!.isEmpty) {
        merchantItems.remove(merchantId);
      }
      update();
    }
  }

  void clearCart() {
    merchantItems.clear();
    update();
  }

  int get itemCount {
    int count = 0;
    merchantItems.forEach((_, items) => count += items.length);
    return count;
  }

  void updateQuantity(int merchantId, int index, int newQuantity) {
    if (merchantItems.containsKey(merchantId) &&
        index >= 0 &&
        index < merchantItems[merchantId]!.length &&
        newQuantity > 0) {
      final item = merchantItems[merchantId]![index];
      merchantItems[merchantId]![index] = CartItemModel(
        product: item.product,
        quantity: newQuantity,
        selectedVariant: item.selectedVariant,
        merchant: item.merchant,
      );
      update();
    }
  }

  void incrementQuantity(int merchantId, int index) {
    if (merchantItems.containsKey(merchantId) &&
        index >= 0 &&
        index < merchantItems[merchantId]!.length) {
      updateQuantity(
          merchantId, index, merchantItems[merchantId]![index].quantity + 1);
    }
  }

  void decrementQuantity(int merchantId, int index) {
    if (merchantItems.containsKey(merchantId) &&
        index >= 0 &&
        index < merchantItems[merchantId]!.length &&
        merchantItems[merchantId]![index].quantity > 1) {
      updateQuantity(
          merchantId, index, merchantItems[merchantId]![index].quantity - 1);
    }
  }

  double getMerchantTotal(int merchantId) {
    if (!merchantItems.containsKey(merchantId)) return 0;
    return merchantItems[merchantId]!
        .fold(0, (sum, item) => sum + item.totalPrice);
  }

  bool validateCart() {
    if (merchantItems.isEmpty) {
      showCustomSnackbar(
        title: 'Keranjang Kosong',
        message: 'Silakan tambahkan produk ke keranjang',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    bool allMerchantsActive = merchantItems.keys.every((merchantId) {
      final merchant = merchantItems[merchantId]!.first.merchant;
      if (!merchant.isActive) {
        showCustomSnackbar(
          title: 'Merchant Tidak Aktif',
          message: 'Merchant ${merchant.name} sedang tidak aktif',
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
      return true;
    });

    return allMerchantsActive;
  }
}
