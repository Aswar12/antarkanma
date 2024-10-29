import 'package:antarkanma/app/controllers/cart_controller.dart';
import 'package:antarkanma/app/data/models/cart_item_model.dart';
import 'package:antarkanma/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Hapus Semua?'),
                  content: const Text('Yakin ingin mengosongkan keranjang?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.clearCart();
                        Get.back();
                      },
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: GetBuilder<CartController>(
        builder: (controller) {
          if (controller.merchantItems.isEmpty) {
            return _buildEmptyCart();
          }
          return _buildCartList();
        },
      ),
      bottomNavigationBar: _buildCheckoutBar(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Keranjang Belanja Kosong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Get.offAllNamed('/home'),
            child: const Text('Mulai Belanja'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.merchantItems.length,
      itemBuilder: (context, index) {
        final merchantId = controller.merchantItems.keys.elementAt(index);
        final merchantItems = controller.merchantItems[merchantId]!;
        return _buildMerchantSection(merchantId as String, merchantItems);
      },
    );
  }

  Widget _buildMerchantSection(String merchantId, List<CartItemModel> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              items.first.merchant.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) =>
                _buildCartItem(merchantId, items[index], index),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(String merchantId, CartItemModel item, int index) {
    return Dismissible(
      key: Key('$merchantId-${item.product.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Hapus Item?'),
            content:
                const Text('Yakin ingin menghapus item ini dari keranjang?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  controller.removeFromCart(merchantId as int, index);
                  Get.back(result: true);
                },
                child: const Text('Hapus'),
              ),
            ],
          ),
        );
      },
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.product.imageUrls.first,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
        ),
        title: Text(item.product.name ?? ''),
        subtitle: Text(
          NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
              .format(item.totalPrice),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () =>
                  controller.decrementQuantity(merchantId as int, index),
            ),
            Text('${item.quantity}'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  controller.incrementQuantity(merchantId as int, index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Pembayaran',
                      style: TextStyle(color: Colors.grey[600])),
                  GetBuilder<CartController>(
                    builder: (controller) => Text(
                      NumberFormat.currency(
                              locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                          .format(controller.totalPrice),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: logoColorSecondary),
                    ),
                  ),
                ],
              ),
            ),
            GetBuilder<CartController>(
              builder: (controller) => ElevatedButton(
                onPressed: controller.itemCount > 0
                    ? () {
                        Get.toNamed('/checkout', arguments: {
                          'merchantItems': controller.merchantItems,
                          'type': 'cart',
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.itemCount > 0
                      ? logoColorSecondary
                      : Colors.grey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
