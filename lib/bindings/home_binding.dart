import 'package:get/get.dart';
import 'package:sup_chat/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
