import 'package:get/get.dart';
import 'package:learning_statemanejment/getx/app/data/model/product_modal.dart';

class HomeController extends GetxController {
  final product = <ProductModal>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProduct();
  }

  void loadProduct(){
    product.value = [
      ProductModal(id: 1, name: 'Vinay', description: 'Sample description', price: 100),
      ProductModal(id: 2, name: 'Laptop', description: 'High-performance laptop', price: 75000),
      ProductModal(id: 3, name: 'Mobile Phone', description: 'Android smartphone', price: 15000),
      ProductModal(id: 4, name: 'Headphones', description: 'Wireless noise-cancelling headphones', price: 3500),
      ProductModal(id: 5, name: 'Smartwatch', description: 'Fitness tracking smartwatch', price: 5000),
    ];
  }

  void gotoProductDetail(ProductModal products){
    Get.toNamed('/productDetail', arguments: products);
  }
}