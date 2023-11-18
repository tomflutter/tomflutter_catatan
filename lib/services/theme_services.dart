import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
    update(); // This will trigger a rebuild of GetBuilder<ThemeServices>
  }

  Icon get icon => _loadThemeFromBox()
      ? const Icon(
          Icons.wb_sunny_outlined,
          color: Colors.white,
        )
      : const Icon(Icons.nightlight_round, color: Colors.black);
}
