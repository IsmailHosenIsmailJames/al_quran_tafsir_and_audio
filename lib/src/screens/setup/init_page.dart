import 'package:al_quran_tafsir_and_audio/src/core/audio/resources/recitation_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/home_page.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/collect_info/collect_info_mobile.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/download/download.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/info_controller/info_controller_getx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    InfoController infoController = Get.find();

    final userBox = Hive.box('user_db');
    final selection = userBox.get('selection_info', defaultValue: null);
    if (selection == null) {
      return const CollectInfoPage(pageNumber: 0);
    }

    infoController.translationLanguage.value =
        selection['translation_language'];
    infoController.bookIDTranslation.value = selection['translation_book_ID'];
    infoController.tafsirLanguage.value = selection['tafsir_language'];
    infoController.tafsirBookID.value = selection['tafsir_book_ID'];
    infoController.selectedReciter.value =
        ReciterInfoModel.fromJson(selection['selected_reciter']);
    if (!(Hive.box('quran_db').keys.isNotEmpty &&
        Hive.box('translation_db').keys.isNotEmpty &&
        Hive.box('tafsir_db').keys.isNotEmpty)) {
      return DownloadData(
        selection: Map<String, dynamic>.from(selection),
      );
    }
    return const HomePage();
  }
}
