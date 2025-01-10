import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:antarkanma/app/controllers/order_controller.dart';
import 'package:antarkanma/app/data/models/transaction_model.dart';
import 'package:antarkanma/app/widgets/order_status_badge.dart';
import 'package:antarkanma/app/utils/order_utils.dart';
import 'package:antarkanma/theme.dart';

class OrderCard extends StatelessWidget {
  final TransactionModel transaction;
  final Function(TransactionModel) onTap;

  const OrderCard({
    Key? key,
    required this.transaction,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = transaction.items.isNotEmpty 
        ? transaction.items 
        : (transaction.order?.orderItems ?? []);
    
    final orderId = (transaction.orderId ?? transaction.id)?.toString() ?? 'Unknown';
    final status = transaction.status;
    final date = transaction.createdAt != null
        ? DateFormat('dd MMM yyyy HH:mm').format(transaction.createdAt!)
        : '-';

    return GestureDetector(
      onTap: () => onTap(transaction),
      child: Container(
        margin: EdgeInsets.only(bottom: Dimenssions.height12),
        decoration: BoxDecoration(
          color: backgroundColor2,
          borderRadius: BorderRadius.circular(Dimenssions.radius15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(orderId, status, date),
            _buildContent(items, status),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String orderId, String status, String date) {
    return Container(
      padding: EdgeInsets.all(Dimenssions.height12),
      decoration: BoxDecoration(
        color: backgroundColor3.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimenssions.radius15),
          topRight: Radius.circular(Dimenssions.radius15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Dimenssions.height6),
                  decoration: BoxDecoration(
                    color: logoColorSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimenssions.radius8),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: Dimenssions.font18,
                    color: logoColorSecondary,
                  ),
                ),
                SizedBox(width: Dimenssions.width8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #$orderId',
                        style: primaryTextStyle.copyWith(
                          fontSize: Dimenssions.font14,
                          fontWeight: semiBold,
                        ),
                      ),
                      SizedBox(height: Dimenssions.height2),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: Dimenssions.font12,
                            color: secondaryTextColor,
                          ),
                          SizedBox(width: Dimenssions.width4),
                          Text(
                            date,
                            style: secondaryTextStyle.copyWith(
                              fontSize: Dimenssions.font12,
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
          OrderStatusBadge(status: status),
        ],
      ),
    );
  }

  Widget _buildContent(List<dynamic> items, String status) {
    return Container(
      padding: EdgeInsets.all(Dimenssions.height12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (items.isNotEmpty) ...[
            ...items.take(2).map((item) => _buildProductItem(item)),
            if (items.length > 2)
              Padding(
                padding: EdgeInsets.only(bottom: Dimenssions.height8),
                child: Text(
                  '+ ${items.length - 2} item lainnya',
                  style: secondaryTextStyle.copyWith(
                    fontSize: Dimenssions.font12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            Divider(
              height: 1,
              thickness: 1,
              color: backgroundColor3.withOpacity(0.1),
            ),
            SizedBox(height: Dimenssions.height8),
          ],
          _buildFooter(status),
        ],
      ),
    );
  }

  Widget _buildProductItem(dynamic item) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimenssions.height8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Dimenssions.height65,
            height: Dimenssions.height65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimenssions.radius8),
              border: Border.all(
                color: backgroundColor3.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimenssions.radius8),
              child: Image.network(
                item.product.firstImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      color: backgroundColor3.withOpacity(0.1),
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: secondaryTextColor,
                        size: Dimenssions.font20,
                      ),
                    ),
              ),
            ),
          ),
          SizedBox(width: Dimenssions.width8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: primaryTextStyle.copyWith(
                    fontSize: Dimenssions.font12,
                    fontWeight: medium,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Dimenssions.height2),
                Text(
                  'Toko: ${item.merchant.name}',
                  style: secondaryTextStyle.copyWith(
                    fontSize: Dimenssions.font12,
                  ),
                ),
                SizedBox(height: Dimenssions.height4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimenssions.width6,
                        vertical: Dimenssions.height2,
                      ),
                      decoration: BoxDecoration(
                        color: logoColorSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Dimenssions.radius6),
                      ),
                      child: Text(
                        '${item.quantity} item',
                        style: primaryTextStyle.copyWith(
                          fontSize: Dimenssions.font12,
                          color: logoColorSecondary,
                        ),
                      ),
                    ),
                    SizedBox(width: Dimenssions.width8),
                    Text(
                      formatPrice(item.price.toDouble()),
                      style: priceTextStyle.copyWith(
                        fontSize: Dimenssions.font12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Pembayaran',
              style: secondaryTextStyle.copyWith(
                fontSize: Dimenssions.font12,
              ),
            ),
            SizedBox(height: Dimenssions.height2),
            Text(
              transaction.formattedGrandTotal,
              style: priceTextStyle.copyWith(
                fontSize: Dimenssions.font14,
                fontWeight: semiBold,
              ),
            ),
          ],
        ),
        if (status.toUpperCase() == 'PENDING')
          _buildCancelButton(),
      ],
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () {
        if (transaction.id != null) {
          _showCancelConfirmation();
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: alertColor.withOpacity(0.1),
        padding: EdgeInsets.symmetric(
          horizontal: Dimenssions.width8,
          vertical: Dimenssions.height2,
        ),
        minimumSize: Size(0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimenssions.radius6),
          side: BorderSide(color: alertColor),
        ),
      ),
      child: Text(
        'Batalkan',
        style: primaryTextStyle.copyWith(
          color: alertColor,
          fontSize: Dimenssions.font12,
          fontWeight: medium,
        ),
      ),
    );
  }

  void _showCancelConfirmation() {
    Get.defaultDialog(
      title: 'Konfirmasi Pembatalan',
      titleStyle: primaryTextStyle.copyWith(
        fontSize: Dimenssions.font16,
        fontWeight: semiBold,
      ),
      middleText: 'Apakah Anda yakin ingin membatalkan pesanan ini?',
      middleTextStyle: primaryTextStyle.copyWith(
        fontSize: Dimenssions.font14,
      ),
      contentPadding: EdgeInsets.all(Dimenssions.height20),
      onCancel: () => Get.back(),
      onConfirm: () {
        Get.find<OrderController>().cancelOrder(transaction.id.toString());
        Get.back();
      },
      textConfirm: 'Ya',
      textCancel: 'Tidak',
      confirmTextColor: Colors.white,
      cancelTextColor: logoColorSecondary,
      buttonColor: alertColor,
      radius: Dimenssions.radius12,
    );
  }
}
