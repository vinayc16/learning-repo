import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_statemanejment/getx/app/moduals/product/controller/ecart_detail_controller.dart';

class EcartDetailView extends GetView<EcartDetailController> {
  @override
  Widget build(BuildContext context) {
    final product = controller.ecartProductModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Product Image (Optional placeholder)
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: product.imageUrl != null
                  ? Image.network(product.imageUrl!, fit: BoxFit.cover)
                  : const Icon(Icons.shopping_bag, size: 80, color: Colors.black54),
            ),

            const SizedBox(height: 16),

            // Product Name
            Text(
              product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Rating Row
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 22),
                const SizedBox(width: 5),
                Text(
                  product.rating.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Price
            Text(
              "₹ ${product.price}",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 16),

            // Description Section
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              product.description,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),

            Text(
              product.createdAt.toString(),
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),

            Text(
              product.isFeatured.toString(),
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),

            Text(
              product.stock.toString(),
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
