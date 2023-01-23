import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sup_chat/constants/app_route.dart';
import 'package:sup_chat/constants/app_theme.dart';
import 'package:sup_chat/service/theme_service.dart';
import 'package:sup_chat/service/user_service.dart';

class SettingController extends GetxController {
  final _darkMode = false.obs;
  final themeRepository = Get.find<ThemeService>();

  bool get isDarkMode => _darkMode.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    _darkMode.value = themeRepository.theme == ThemeMode.dark;
    super.onReady();
  }

  void changeTheme(bool isDarkMode) {
    themeRepository.changeTheme(isDarkMode);
    _darkMode.value = isDarkMode;
  }

  void signOut() async {
    await Get.find<UserService>().signOut();
    print('settings sign out');
    Get.offAllNamed(AppRoute.HOME);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
