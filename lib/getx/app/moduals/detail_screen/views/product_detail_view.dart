import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../controller/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Product Detail'),
     ),
     body: Column(
       children: [
         Text('Name: ${controller.productModal.name}'),
         Text('Description: ${controller.productModal.description}'),
         Text('Price: ${controller.productModal.price}'),
         SizedBox(height: 10,),
       Spacer(),
         ElevatedButton(onPressed: controller.goBack, child: Text('Go Back'))
       ],
     ),
     );
  }

}