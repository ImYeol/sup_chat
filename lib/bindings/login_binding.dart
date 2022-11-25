import 'package:get/get.dart';
import 'package:sup_chat/controller/loging_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
