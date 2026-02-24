import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:learning_statemanejment/getx/app/moduals/home_screen/controller/home_controller.dart';

class HomeView extends GetView<HomeController>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Home View'),
     ),
     body: Obx(() {
       return ListView.builder(
         itemCount: controller.product.length,
         itemBuilder: (context, index) {
           final product = controller.product[index];
           return Card(
             margin: EdgeInsets.all(8),
             child: ListTile(
               title: Text(product.name),
               subtitle: Text(product.description),
               trailing: Text('${product.price}'),
               onTap: () => controller.gotoProductDetail(product),
             ),
           );
         }
       );
     },),
   );
  }

}