import 'package:get/get.dart';

import '../controller/ecart_detail_controller.dart';

class EcartDetailBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => EcartDetailController());
  }

}