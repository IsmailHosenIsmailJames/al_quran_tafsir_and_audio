import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

bool isLoggedIn = false;
String quranScriptType = "uthmani_tajweed";

class AppThemeData extends GetxController {
  RxString themeModeName = 'system'.obs;
  RxBool isDark = true.obs;

  void initTheme() async {
    final accountBox = Hive.box("user_db");

    isLoggedIn =
        accountBox.get("email") != "" && accountBox.get("email") != null;
    final infoBox = Hive.box("user_db");
    final fonSize = Get.put(UniversalController());

    fonSize.fontSizeArabic.value =
        infoBox.get("fontSizeArabic", defaultValue: 24.0);
    fonSize.fontSizeTranslation.value =
        infoBox.get("fontSizeTranslation", defaultValue: 15.0);
    quranScriptType =
        infoBox.get("quranScriptType", defaultValue: "uthmani_tajweed");
    fonSize.quranScriptTypeGetx.value =
        infoBox.get("quranScriptType", defaultValue: "uthmani_tajweed");

    final themePrefer = await Hive.openBox("user_db");
    final String? userTheme = themePrefer.get('theme_preference');
    if (userTheme != null) {
      if (userTheme == 'light') {
        isDark.value = false;
        Get.changeThemeMode(ThemeMode.light);
        themeModeName.value = 'light';
        await themePrefer.put("theme_preference", themeModeName.value);
      } else if (userTheme == 'dark') {
        isDark.value = true;

        Get.changeThemeMode(ThemeMode.dark);
        themeModeName.value = 'dark';
        await themePrefer.put("theme_preference", themeModeName.value);
      } else if (userTheme == 'system') {
        Get.changeThemeMode(ThemeMode.system);
        themeModeName.value = 'system';
        Get.changeThemeMode(ThemeMode.system);
      }
    } else {
      await themePrefer.put('theme_preference', 'system');
      initTheme();
    }
  }

  void setTheme(String themeToChange) async {
    final themePrefer = await Hive.openBox("user_db");
    if (themeToChange == 'light') {
      isDark.value = false;

      Get.changeThemeMode(ThemeMode.light);
      themeModeName.value = 'light';
      await themePrefer.put('theme_preference', themeModeName.value);
    } else if (themeToChange == 'dark') {
      isDark.value = true;

      themeModeName.value = 'dark';
      Get.changeThemeMode(ThemeMode.dark);
      await themePrefer.put('theme_preference', 'dark');
    } else if (themeToChange == 'system') {
      themeModeName.value = 'system';
      Get.changeThemeMode(ThemeMode.system);
      await themePrefer.put('theme_preference', 'system');
    }
  }
}
