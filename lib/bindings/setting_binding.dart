import 'package:get/get.dart';
import 'package:sup_chat/controller/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}
