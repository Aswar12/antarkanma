import 'package:antarkanma/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:antarkanma/app/controllers/checkout_controller.dart';
import 'package:antarkanma/app/data/models/user_location_model.dart';
import 'package:antarkanma/app/data/models/transaction_model.dart';
import 'package:antarkanma/app/data/models/order_model.dart';
import 'package:antarkanma/app/data/models/order_item_model.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor8,
      appBar: AppBar(
        backgroundColor: backgroundColor8,
        iconTheme: IconThemeData(
          color: logoColorSecondary,
        ),
        title: Text(
          'Checkout',
          style: primaryTextStyle,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDeliveryAddressSection(),
                const SizedBox(height: 16),
                _buildOrderItemsSection(),
                const SizedBox(height: 16),
                _buildPaymentSection(),
                const SizedBox(height: 16),
                _buildTotalSection(),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: _buildCheckoutButton(),
    );
  }

  Widget _buildDeliveryAddressSection() {
    return Card(
      color: backgroundColor1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Alamat Pengiriman',
                  style: primaryTextStyle,
                ),
                TextButton(
                  onPressed: () => Get.toNamed('/address-selection'),
                  child: Text(
                    'Ubah',
                    style: primaryTextStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => controller.selectedLocation.value != null
                ? _buildAddressCard(controller.selectedLocation.value!)
                : _buildNoAddressWidget()),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(UserLocationModel location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              location.addressLabel,
              style: primaryTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            if (location.isDefault)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Utama',
                  style: primaryTextStyle.copyWith(
                    color: logoColor,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          location.customerName ?? '',
          style: primaryTextStyle,
        ),
        Text(
          location.formattedPhoneNumber,
          style: primaryTextStyle,
        ),
        const SizedBox(height: 4),
        Text(
          location.fullAddress,
          style: primaryTextStyle,
        ),
        if (location.notes?.isNotEmpty ?? false) ...[
          const SizedBox(height: 4),
          Text(
            'Catatan: ${location.notes}',
            style: primaryTextStyle.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ],
    );
  }

  Widget _buildNoAddressWidget() {
    return InkWell(
      onTap: () => Get.toNamed('/address-selection'),
      child: Card(
        color: backgroundColor8,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: logoColorSecondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.add_location_alt_outlined,
                  color: logoColorSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Pilih Alamat Pengiriman',
                style: primaryTextStyle.copyWith(
                  fontSize: Dimenssions.font16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItemsSection() {
    return Card(
      color: backgroundColor1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...controller.orderItems
                .map((item) => _buildOrderItemCard(item))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemCard(OrderItemModel item) {
    return Card(
      color: backgroundColor8,
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.product.firstImageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: Icon(Icons.error, color: Colors.red),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: primaryTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: Dimenssions.font16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Merchant: ${item.merchantName}',
                    style: primaryTextStyle.copyWith(
                      fontSize: Dimenssions.font14,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.quantity}x ${item.formattedPrice}',
                        style: primaryTextStyle.copyWith(
                          color: logoColor,
                          fontSize: Dimenssions.font16,
                        ),
                      ),
                      Text(
                        item.formattedTotalPrice,
                        style: primaryTextStyle.copyWith(
                          color: logoColor,
                          fontSize: Dimenssions.font18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Card(
      color: backgroundColor1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Metode Pembayaran',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => controller.selectedPaymentMethod.value != null
                ? _buildPaymentMethodCard(
                    controller.selectedPaymentMethod.value!)
                : _buildNoPaymentMethodWidget()),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(String method) {
    return ListTile(
      tileColor: backgroundColor8,
      title: Text(
        method,
        style: primaryTextStyle,
      ),
      trailing: TextButton(
        onPressed: () => Get.toNamed('/payment-selection'),
        child: Text(
          'Ubah',
          style: primaryTextStyle,
        ),
      ),
    );
  }

  Widget _buildNoPaymentMethodWidget() {
    return InkWell(
      onTap: () => Get.toNamed('/payment-selection'),
      child: Card(
        color: backgroundColor8,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: logoColorSecondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.payment,
                  color: logoColorSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Pilih Metode Pembayaran',
                style: primaryTextStyle.copyWith(
                  fontSize: Dimenssions.font16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    return Card(
      color: backgroundColor1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTotalRow('Subtotal', controller.subtotal.value),
            _buildTotalRow('Biaya Pengiriman', controller.deliveryFee.value),
            const Divider(),
            _buildTotalRow('Total', controller.total.value, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: primaryTextStyle.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(amount),
            style: primaryTextStyle.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Card(
      // Menggunakan Card untuk konsistensi bayangan
      margin: EdgeInsets.zero, // Menghilangkan margin default Card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Dimenssions.radius20),
          topLeft: Radius.circular(Dimenssions.radius20),
        ),
      ),
      color: backgroundColor1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Pembayaran',
                  style: primaryTextStyle.copyWith(
                    fontSize: Dimenssions.font16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(controller.total.value),
                  style: primaryTextStyle.copyWith(
                    fontSize: Dimenssions.font18,
                    fontWeight: FontWeight.bold,
                    color: logoColorSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Card(
              // Menggunakan Card untuk tombol juga
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: controller.canCheckout
                    ? () => controller.processCheckout()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: logoColorSecondary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 54),
                  padding: EdgeInsets.zero,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: controller.canCheckout
                        ? LinearGradient(
                            colors: [
                              logoColorSecondary,
                              logoColorSecondary.withOpacity(0.8),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_checkout,
                          color: controller.canCheckout
                              ? logoColor
                              : logoColorSecondary,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          controller.canCheckout
                              ? 'Bayar Sekarang'
                              : 'Lengkapi Pesanan',
                          style: primaryTextStyle.copyWith(
                            color: controller.canCheckout
                                ? logoColor
                                : logoColorSecondary,
                            fontSize: Dimenssions.font16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!controller.canCheckout)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Lengkapi alamat dan metode pembayaran',
                  style: primaryTextStyle.copyWith(
                    color: Colors.red[400],
                    fontSize: Dimenssions.font12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
