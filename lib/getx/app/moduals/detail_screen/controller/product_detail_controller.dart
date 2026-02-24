import 'package:get/get.dart';
import 'package:learning_statemanejment/getx/app/data/model/product_modal.dart';

class ProductDetailController extends GetxController {
  late ProductModal productModal;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    productModal = Get.arguments as ProductModal;
  }

  void goBack() {
    Get.back();
  }
}
