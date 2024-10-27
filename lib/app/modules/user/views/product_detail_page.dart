// ignore: unused_import
import 'package:antarkanma/app/constants/app_colors.dart';
import 'package:antarkanma/app/utils/image_viewer_page.dart';
import 'package:antarkanma/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:antarkanma/app/controllers/product_detail_controller.dart';
import 'package:antarkanma/app/data/models/product_model.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as ProductModel;

    controller.setProduct(product);

    return Scaffold(
      backgroundColor: backgroundColor5,
      appBar: AppBar(
        title:
            Obx(() => Text(controller.product.value.name ?? 'Detail Produk')),
        backgroundColor: transparentColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_bag_rounded,
              color: logoColorSecondary,
            ),
            onPressed: () {
              Share.share('Check out this product: ${product.name}');
            },
          )
        ],
      ),
      body: Obx(() {
        final product = controller.product.value;

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildImageSlider(product.imageUrls ?? []),
              _buildProductInfo(product),
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(Dimenssions.height10),
        decoration: BoxDecoration(
          color: backgroundColor5,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Wishlist Button
              Container(
                width: Dimenssions.width55,
                height: Dimenssions.width55,
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: logoColorSecondary),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.chat,
                    color: logoColorSecondary,
                  ),
                  onPressed: () {
                    final merchant = controller.product.value.merchant;
                    if (merchant != null) {
                      Get.toNamed('/chat', arguments: {
                        'merchantId': merchant.id,
                        'merchantName': merchant.name,
                      });
                    } else {
                      Get.snackbar(
                        'Error',
                        'Tidak dapat memulai chat dengan penjual',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ),
              // Buy Now Button
              Expanded(
                child: Container(
                  height: Dimenssions.width55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: logoColorSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (controller.product.value.status != 'ACTIVE') {
                        Get.snackbar(
                          'Tidak Tersedia',
                          'Produk ini sedang tidak tersedia',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      final product = controller.product.value;
                      final quantity = controller.quantity.value;

                      Get.toNamed('/checkout', arguments: {
                        'product': product,
                        'quantity': quantity,
                        'type': 'direct_buy',
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_checkout,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Beli Sekarang',
                          style: primaryTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider(List<String> imageUrls) {
    final List<String> placeholderImages = [
      'assets/image_shoes.png',
      'assets/image_shoes2.png',
      'assets/image_shoes3.png',
    ];

    final List<String> displayImages =
        imageUrls.isEmpty ? placeholderImages : imageUrls;

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: displayImages.length,
          options: CarouselOptions(
            height: Dimenssions.popularFoodDetailImgSize,
            viewportFraction: 0.8,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            enlargeFactor: 0.3,
            autoPlay: displayImages.length > 1,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, _) {
              controller.updateImageIndex(index);
            },
            padEnds: true,
          ),
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                Get.to(
                  () => ImageViewerPage(
                    imageUrls: displayImages,
                    initialIndex: index,
                  ),
                  transition: Transition.zoom,
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[200],
                ),
                child: Hero(
                  tag: "Image_$index",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: imageUrls.isEmpty
                        ? Image.asset(
                            displayImages[index],
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            displayImages[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/image_shoes.png',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Obx(() {
            // Pastikan currentImageIndex tidak null
            final currentIndex = controller.currentImageIndex.value;
            return Center(
              child: AnimatedSmoothIndicator(
                activeIndex: currentIndex,
                count: displayImages.length,
                effect: WormEffect(
                  dotWidth: 11,
                  dotHeight: 11,
                  spacing: 10,
                  strokeWidth: 1,
                  dotColor: Colors.grey.shade400,
                  activeDotColor: logoColorSecondary,
                  paintStyle: PaintingStyle.stroke,
                  type: WormType.thinUnderground,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(
            'Jumlah:',
            style: primaryTextStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: Dimenssions.width10),
          Row(
            children: [
              _buildQuantityButton(
                icon: Icons.remove,
                onTap: () => controller.decrementQuantity(),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: Dimenssions.width15),
                child: Obx(() => Text(
                      controller.quantity.value.toString(),
                      style: primaryTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
              _buildQuantityButton(
                icon: Icons.add,
                onTap: () => controller.incrementQuantity(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 200),
        tween: Tween<double>(begin: 1, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: logoColorSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: logoColorSecondary.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 20,
                color: logoColorSecondary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductInfo(ProductModel product) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.name ?? 'Unknown Product',
                  style: primaryTextStyle.copyWith(
                    fontSize: Dimenssions.height30,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: product.status == 'ACTIVE'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.status ?? 'Habismi',
                  style: TextStyle(
                    color:
                        product.status == 'ACTIVE' ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

// Price and Category Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Rp ${product.price?.toString() ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 20,
                  color: logoColorSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: logoColorSecondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.category?.name ?? 'No Category',
                  style: TextStyle(
                    color: logoColorSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          // Description
          Text(
            'Deskripsi Produk',
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description ?? 'No description available',
            style: TextStyle(
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          SizedBox(height: Dimenssions.height25),

          // Merchant Information
          Container(
            padding: EdgeInsets.all(Dimenssions.height22),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Toko',
                  style: TextStyle(
                    fontSize: 18,
                    color: primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.store, color: logoColorSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        product.merchant?.name ?? 'Unknown Merchant',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: logoColorSecondary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        product.merchant?.address ?? 'No address available',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone, color: logoColorSecondary),
                    SizedBox(width: 8),
                    Text(
                      product.merchant?.phoneNumber ?? 'No phone number',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildQuantitySelector(),
              SizedBox(
                width: Dimenssions.width20,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement add to cart functionality
                    final quantity = controller.quantity.value;
                    Get.snackbar(
                      'Added to Cart',
                      '${product.name} (${quantity}x) added to cart',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: logoColorSecondary,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: logoColorSecondary,
                    padding:
                        EdgeInsets.symmetric(vertical: Dimenssions.height15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Tambah ke Keranjang',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: Dimenssions.font18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Add to Cart Button
        ],
      ),
    );
  }
}
