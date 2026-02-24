import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:learning_statemanejment/getx/app/moduals/home_screen/binding/home_binding.dart';
import 'package:learning_statemanejment/getx/app/moduals/product/binding/ecart_detail_binding.dart';
import 'package:learning_statemanejment/getx/app/moduals/product/view/ecart_detail_view.dart';
import '../moduals/detail_screen/bindings/product_detail_binding.dart';
import '../moduals/detail_screen/views/product_detail_view.dart';
import '../moduals/home_screen/views/home_view.dart';
import '../moduals/product/binding/ecart_binding.dart';
import '../moduals/product/view/ecart_view.dart';

class AppRoutes {
  static final routes=[
    GetPage(name: '/home', page: () => HomeView(),binding: HomeBinding()),
    GetPage(name: '/productDetail', page: () => ProductDetailView(), binding: ProductDetailBinding()),
    GetPage(name: '/ecartPage', page: () => EcartView(), binding: EcartBinding(),),
    GetPage(name: '/EproductDetail', page: () => EcartDetailView(), binding: EcartDetailBinding())
    // GetPage(name: '/productDetail', page: () => ProductDetailView()),
  ];
}