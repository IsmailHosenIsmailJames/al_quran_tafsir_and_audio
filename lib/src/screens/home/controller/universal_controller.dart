import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UniversalController extends GetxController {
  RxDouble fontSizeArabic = 24.0.obs;
  RxDouble fontSizeTranslation = 15.0.obs;
  RxString quranScriptTypeGetx = Hive.box("user_db")
      .get("quranScriptType", defaultValue: "uthmani_tajweed")
      .toString()
      .obs;
  RxInt surahViewTabIndex = 0.obs;
  RxInt quranTabIndex = 0.obs;
  RxInt collectionTabIndex = 0.obs;
}

List<String> quranScriptTypeList = [
  "indopak",
  "uthmani_tajweed",
  "uthmani",
  "uthmani_simple",
  "imlaei",
];
