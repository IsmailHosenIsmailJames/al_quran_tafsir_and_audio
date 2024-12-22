import 'package:al_quran_tafsir_and_audio/src/screens/home/home_page.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/collect_info/collect_info_mobile.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/download/download%20copy.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box("user_db");
    final userInfo = userBox.get("info", defaultValue: false);
    final quranBox = Hive.box("quran_db");
    final tafsirBox = Hive.box("tafsir_db");
    if (userInfo == false) {
      return const CollectInfoPage(pageNumber: 0);
    }

    if (!(quranBox.get('quran_info', defaultValue: false) &&
        quranBox.get('quran', defaultValue: false) &&
        quranBox.get('translation', defaultValue: false) &&
        tafsirBox.get('tafsir', defaultValue: false))) {
      return const DownloadData();
    }
    return const HomePage();
  }
}
