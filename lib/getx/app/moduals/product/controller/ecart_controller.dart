import 'package:get/get.dart';
import '../../../data/model/ecart_modal.dart';

class EcartController extends GetxController{
  final product = <EcartProductModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    laodeProduct();
  }

  void laodeProduct() async{
    product.clear(); // show loader
    await Future.delayed(const Duration(seconds: 1)); // simulate API

    product.value = [
      EcartProductModel(
        id: 1,
        name: 'Vinay',
        description: 'Sample description',
        price: 100,
        rating: 4.5,
        stock: 10,
        isFeatured: true,
        category: 'Electronics',
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2gL1ZUkl8AKPvywtkmX_BP9dlJxzq8XnQ1g&s',
        createdAt: DateTime.now(),
      ),
      EcartProductModel(
        id: 2,
        name: 'Nike Shoes',
        description: 'Comfortable running shoes designed for daily use.',
        price: 2999,
      ),
      EcartProductModel(
        id: 3,
        name: 'Smart Watch',
        description: 'Tracks heart rate, steps, and notifications.',
        price: 4999,
      ),
      EcartProductModel(
        id: 4,
        name: 'Bluetooth Headphones',
        description: 'Premium audio with noise cancellation.',
        price: 1999,
      ),
      EcartProductModel(
        id: 5,
        name: 'Gaming Mouse',
        description: 'RGB mouse with high DPI settings.',
        price: 1599,
      ),
      EcartProductModel(
        id: 6,
        name: 'Laptop Stand',
        description: 'Adjustable aluminium laptop stand.',
        price: 999,
      ),
    ];
  }

  void gotoEcartProductDetail(EcartProductModel ecartProductModel){
    Get.toNamed('/EproductDetail', arguments: ecartProductModel);
  }

}