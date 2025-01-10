import 'package:al_quran_tafsir_and_audio/src/core/audio/controller/audio_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/info_controller/info_controller_getx.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/init_page.dart';
import 'package:al_quran_tafsir_and_audio/src/theme/theme_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/translations/language_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/translations/map_of_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:toastification/toastification.dart';
import 'dart:ui' as ui;

class AlQuranTafsirAndAudio extends StatelessWidget {
  const AlQuranTafsirAndAudio({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Al-Quran',
        theme: ThemeData.light().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green.shade700,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.notoSansTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              iconColor: Colors.white,
            ),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.grey.shade800,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green.shade600,
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.notoSansTextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
            decorationColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              iconColor: Colors.white,
            ),
          ),
        ),
        defaultTransition: Transition.leftToRight,
        themeMode: ThemeMode.system,
        locale: Get.deviceLocale,
        fallbackLocale: const ui.Locale("en"),
        translationsKeys: AppTranslation.translationsKeys,
        onInit: () async {
          final appTheme = Get.put(AppThemeData());
          final infoController = Get.put(InfoController());
          Get.put(AudioController());

          final languageController = Get.put(LanguageController());
          final prefBox = Hive.box("user_db");
          String? languageCode = prefBox.get("app_lan", defaultValue: null);
          if (languageCode == null) {
            languageCode ??= Get.locale?.languageCode;
            infoController.appLanCode.value = languageCode ?? '';
            languageController.changeLanguage = languageCode ?? 'en';
          } else {
            languageController.changeLanguage = languageCode;
            infoController.appLanCode.value = languageCode;
          }
          appTheme.initTheme();
        },
        home: const InitPage(),
      ),
    );
  }
}
