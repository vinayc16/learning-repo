import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_statemanejment/getx/app/moduals/product/controller/ecart_controller.dart';

class EcartView extends GetView<EcartController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecart View'),
      ),

      body: Obx(() {

        /// Show Loader When Data is Empty / Loading
        if (controller.product.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: controller.product.length,
          itemBuilder: (context, index) {
            final product = controller.product[index];

            return GestureDetector(
              onTap: () => controller.gotoEcartProductDetail(product),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(product.description),
                    const SizedBox(height: 4),
                    Text(
                      "₹ ${product.price}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}