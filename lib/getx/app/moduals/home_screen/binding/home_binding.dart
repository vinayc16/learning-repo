import 'package:get/get.dart';

import '../controller/home_controller.dart';

class HomeBinding extends Bindings{

  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => HomeController());
  }
}

//put- create new
//lazyput- create a latter (when use) and use efficiently memory