// // lib/app/modules/checkout/views/checkout_page.dart
// import 'package:antarkanma/theme.dart';
// import 'package:flutter/material.dart';

// class CheckoutPage extends GetView<CheckoutController> {
//   const CheckoutPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: Dimenssions.height45,
//         title: Text(
//           'Checkout',
//           style: primaryTextStyle.copyWith(
//             fontSize: Dimenssions.font20,
//             fontWeight: regular,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         foregroundColor: primaryTextColor,
//         elevation: 0.5,
//         shape: Border(
//           bottom: BorderSide(
//             color: Colors.grey.withOpacity(0.2),
//             width: 1,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Alamat Pengiriman
//             _buildDeliveryAddress(),

//             // Daftar Item
//             _buildOrderItems(),

//             // Metode Pembayaran
//             _buildPaymentMethod(),

//             // Ringkasan Pembayaran
//             _buildOrderSummary(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomBar(),
//     );
//   }

//   Widget _buildDeliveryAddress() {
//     return Container(
//       padding: EdgeInsets.all(Dimenssions.height15),
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Alamat Pengiriman',
//             style: primaryTextStyle.copyWith(
//               fontSize: Dimenssions.font16,
//               fontWeight: semiBold,
//             ),
//           ),
//           SizedBox(height: Dimenssions.height10),
//           // Tampilkan alamat yang dipilih
//           Obx(() => controller.selectedAddress.value != null
//               ? _buildAddressCard(controller.selectedAddress.value!)
//               : _buildAddAddressButton()),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderItems() {
//     return Container(
//       margin: EdgeInsets.only(top: Dimenssions.height10),
//       padding: EdgeInsets.all(Dimenssions.height15),
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Pesanan',
//             style: primaryTextStyle.copyWith(
//               fontSize: Dimenssions.font16,
//               fontWeight: semiBold,
//             ),
//           ),
//           SizedBox(height: Dimenssions.height10),
//           // List items dari cart
//           Obx(() => Column(
//                 children: controller.cartItems
//                     .map((item) => _buildOrderItemCard(item))
//                     .toList(),
//               )),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentMethod() {
//     return Container(
//       margin: EdgeInsets.only(top: Dimenssions.height10),
//       padding: EdgeInsets.all(Dimenssions.height15),
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Metode Pembayaran',
//             style: primaryTextStyle.copyWith(
//               fontSize: Dimenssions.font16,
//               fontWeight: semiBold,
//             ),
//           ),
//           SizedBox(height: Dimenssions.height10),
//           // List metode pembayaran
//           Obx(() => Column(
//                 children: controller.paymentMethods
//                     .map((method) => _buildPaymentMethodCard(method))
//                     .toList(),
//               )),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderSummary() {
//     return Container(
//       margin: EdgeInsets.only(top: Dimenssions.height10),
//       padding: EdgeInsets.all(Dimenssions.height15),
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Ringkasan Pembayaran',
//             style: primaryTextStyle.copyWith(
//               fontSize: Dimenssions.font16,
//               fontWeight: semiBold,
//             ),
//           ),
//           SizedBox(height: Dimenssions.height10),
//           _buildSummaryItem('Subtotal', controller.subtotal),
//           _buildSummaryItem('Biaya Pengiriman', controller.deliveryFee),
//           _buildSummaryItem('Total', controller.total, isTotal: true),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomBar() {
//     return Container(
//       padding: EdgeInsets.all(Dimenssions.height15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: Offset(0, -1),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Total Pembayaran',
//                   style: primaryTextStyle.copyWith(
//                     fontSize: Dimenssions.font14,
//                   ),
//                 ),
//                 Obx(() => Text(
//                       NumberFormat.currency(
//                         locale: 'id',
//                         symbol: 'Rp ',
//                         decimalDigits: 0,
//                       ).format(controller.total.value),
//                       style: primaryTextStyle.copyWith(
//                         fontSize: Dimenssions.font18,
//                         fontWeight: semiBold,
//                         color: logoColorSecondary,
//                       ),
//                     )),
//               ],
//             ),
//           ),
//           SizedBox(width: Dimenssions.width15),
//           ElevatedButton(
//             onPressed: () => controller.processCheckout(),
//             style: ElevatedButton.styleFrom(
//               primary: logoColorSecondary,
//               padding: EdgeInsets.symmetric(
//                 horizontal: Dimenssions.width30,
//                 vertical: Dimenssions.height15,
//               ),
//             ),
//             child: Text(
//               'Bayar Sekarang',
//               style: primaryTextStyle.copyWith(
//                 color: Colors.white,
//                 fontWeight: medium,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
