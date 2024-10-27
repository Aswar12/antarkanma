import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:antarkanma/app/controllers/product_detail.controller.dart';
import 'package:antarkanma/app/data/models/product_model.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({Key? key, required ProductModel product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Obx(() => Text(controller.product.value.name ?? 'Detail Produk')),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final product = controller.product.value;

        // Tampilkan loading jika product.id masih null
        if (product.id == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildImageSlider(product.imageUrls),
              _buildProductInfo(product),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImageSlider(List<String> imageUrls) {
    return Container(
      height: 300,
      child: imageUrls.isEmpty
          ? Image.asset(
              'assets/placeholder.png',
              fit: BoxFit.cover,
            )
          : PageView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(imageUrls[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildProductInfo(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name ?? 'Unnamed Product',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.formattedPrice,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Deskripsi:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description ?? 'Deskripsi tidak tersedia',
            style: const TextStyle(fontSize: 16),
          ),
          if (product.merchant != null) ...[
            const SizedBox(height: 16),
            Text(
              'Merchant: ${product.merchant!.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          if (product.tags != null && product.tags!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Tags: ${product.tags}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }
}
