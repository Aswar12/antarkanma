import 'package:antarkanma/app/controllers/product_controller.dart';
import 'package:antarkanma/app/data/models/product_model.dart';
import 'package:antarkanma/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductPage extends GetView<ProductController> {
  final ProductModel product;

  ProductPage(this.product, {super.key}) {
    // Inisialisasi controller
    Get.put(ProductController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => ListView(
            children: [
              // Header with Image Slider
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: controller.setCurrentIndex,
                      itemCount: product.imageUrls.length,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: controller.pageController,
                          builder: (context, child) {
                            double value = 1;
                            if (controller
                                .pageController.position.haveDimensions) {
                              value = controller.pageController.page! - index;
                              value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                            }
                            return Center(
                              child: SizedBox(
                                height: Curves.easeInOut.transform(value) * 300,
                                width: Curves.easeInOut.transform(value) * 400,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: Dimenssions.width10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(product.imageUrls[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Obx(() => SmoothPageIndicator(
                              controller: controller.pageController,
                              count: product.imageUrls.length,
                              effect: const WormEffect(
                                activeDotColor: Color(0xFFFF6600),
                                dotHeight: 10,
                                dotWidth: 10,
                                type: WormType.thin,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Container(
                padding: EdgeInsets.all(Dimenssions.width15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: priceTextStyle.copyWith(
                        fontSize: Dimenssions.font18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      NumberFormat.currency(locale: 'id', symbol: 'Rp ')
                          .format(product.price),
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(product.description),
                  ],
                ),
              ),
            ],
          )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => controller.addToCart(product),
          child: Text('Add to Cart'),
          style: ElevatedButton.styleFrom(
            backgroundColor: logoColorSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
