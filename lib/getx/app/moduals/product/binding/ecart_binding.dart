// import 'package:get/get.dart';

import 'package:get/get.dart';

import '../controller/ecart_controller.dart';

class EcartBinding extends Bindings{

  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => EcartController());
  }
}