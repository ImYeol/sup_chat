import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sup_chat/constants/app_theme.dart';

class SettingController extends GetxController {
  final box = GetStorage('settings');
  final _darkMode = false.obs;
  
  bool get isDarkMode => _darkMode.value;

  @override
  void onInit() {
    box.initStorage;
    super.onInit();
  }

  @override
  void onReady() {
    _darkMode.value = box.read('theme')?? false;
    super.onReady();
  }

  void changeTheme(bool isDarkMode) {
    print('isDarkMode = $isDarkMode');
    Get.changeTheme(isDarkMode ? AppDarkTheme.theme : AppLightTheme.theme).;
    _darkMode.value = isDarkMode;
    update();
    box.write('theme', isDarkMode);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
