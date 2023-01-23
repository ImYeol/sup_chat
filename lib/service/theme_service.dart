import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  final _box = GetStorage("settings");
  final _key = 'isDarkMode';

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.read(_key) ?? false;
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void changeTheme(bool isDarkMode) {
    print('changeTheme isDarkMode = $isDarkMode');
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToBox(isDarkMode);
  }

  Future<bool> initStorage() async {
    final initialized = await _box.initStorage;
    print("theme init : $initialized");
    return initialized;
  }

  // void switchTheme() {
  //   Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
  //   _saveThemeToBox(!_loadThemeFromBox());
  // }
}
