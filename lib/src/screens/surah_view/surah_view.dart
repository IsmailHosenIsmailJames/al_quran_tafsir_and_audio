import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/info_controller/info_controller_getx.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/common/tajweed_scripts_composer.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/info_view/info_view.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/models/surah_view_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/translations/language_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SurahView extends StatefulWidget {
  final int? jumpToAyah;
  final String titleToShow;
  final List<SurahViewInfoModel> surahInfo;
  const SurahView({
    super.key,
    required this.surahInfo,
    this.jumpToAyah,
    required this.titleToShow,
  });

  @override
  State<SurahView> createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  InfoController infoController = Get.find();
  UniversalController universalController = Get.find();
  LanguageController languageController = Get.find();
  String translationBookName = "";
  int totalAyah = 0;
  late int initialAyahID = widget.surahInfo[0].start;

  @override
  void initState() {
    for (var surah in widget.surahInfo) {
      totalAyah += surah.ayahCount;
    }
    for (Map translation in allTranslationLanguage) {
      if ("${translation['id']}" == infoController.bookIDTranslation.value) {
        translationBookName =
            "${translation['name']} by ${translation['author_name']}";
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleToShow),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings_rounded,
              size: 18,
            ),
          )
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(bottom: 100),
        itemCount: totalAyah,
        itemBuilder: (context, index) {
          int currentAyahIndex = initialAyahID + index;
          if (index == 0) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.green.shade700.withValues(alpha: 0.1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              widget.surahInfo[0].revelationPlace
                                          .capitalizeFirst ==
                                      "makkah"
                                  ? "assets/img/makkah.jpg"
                                  : "assets/img/madina.jpeg",
                            ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Gap(10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Surah Name",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            "${widget.surahInfo[0].surahNameSimple.capitalizeFirst} ( ${widget.surahInfo[0].surahNameArabic} )",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Revelation Place",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            "${widget.surahInfo[0].revelationPlace.capitalizeFirst} (${widget.surahInfo[0].revelationPlace == "makkah" ? "مكي" : "مدني"} )",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.green.shade700,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                String url =
                                    "https://api.quran.com/api/v4/chapters/${widget.surahInfo[0].surahNumber}/info";
                                String languageName =
                                    languageController.selectedLanguage.value;
                                log(languageName);
                                Get.to(
                                  () => InfoViewOfSurah(
                                    surahName:
                                        "${widget.surahInfo[0].surahNameSimple} ( ${widget.surahInfo[0].surahNameArabic} )",
                                    infoURL: url,
                                    languageName: languageName,
                                  ),
                                );
                              },
                              icon: Icon(
                                FluentIcons.info_24_filled,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.green.shade700,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {},
                              icon: Icon(
                                Icons.play_arrow_rounded,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (widget.surahInfo[0].isStartWithBismillah == true)
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Obx(
                      () => Text.rich(
                        TextSpan(
                          children: getTajweedTexSpan(
                            startAyahBismillah(
                              universalController.quranScriptTypeGetx.value,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: universalController.fontSizeArabic.value,
                        ),
                      ),
                    ),
                  ),
                buildAyah(index, currentAyahIndex),
              ],
            );
          } else {
            return buildAyah(index, currentAyahIndex);
          }
        },
      ),
    );
  }

  Container buildAyah(int index, int currentAyahIndex) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Row(
              children: [
                Container(
                  height: 30,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.green.shade700.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    (index + 1).toString(),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.green.shade700,
                      backgroundColor:
                          Colors.grey.shade600.withValues(alpha: 0.3),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.play_arrow_rounded,
                    ),
                  ),
                ),
                Gap(10),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: PopupMenuButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor:
                          Colors.grey.shade600.withValues(alpha: 0.3),
                      iconSize: 18,
                    ),
                    itemBuilder: (context) {
                      return [];
                    },
                  ),
                ),
              ],
            ),
          ),
          Gap(10),
          Align(
            alignment: Alignment.topRight,
            child: Obx(
              () => Text.rich(
                TextSpan(
                  children: getTajweedTexSpan(
                    Hive.box("quran_db").get(
                      "uthmani_tajweed/${currentAyahIndex + 1}",
                      defaultValue: "",
                    ),
                  ),
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: universalController.fontSizeArabic.value,
                ),
              ),
            ),
          ),
          Divider(),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Translation book :\n$translationBookName",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Gap(5),
          Align(
            alignment: Alignment.topLeft,
            child: Obx(
              () => Text(
                Hive.box("translation_db").get(
                  "${infoController.bookIDTranslation.value}/$currentAyahIndex",
                  defaultValue: "",
                ),
                style: TextStyle(
                  fontSize: universalController.fontSizeTranslation.value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
