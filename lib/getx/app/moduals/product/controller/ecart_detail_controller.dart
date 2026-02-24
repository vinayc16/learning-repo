
import 'package:get/get.dart';
import 'package:learning_statemanejment/getx/app/data/model/ecart_modal.dart';

class EcartDetailController extends GetxController{
  late EcartProductModel ecartProductModel;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    ecartProductModel = Get.arguments as EcartProductModel;
  }

  void goBack() {
    Get.back();
  }
}