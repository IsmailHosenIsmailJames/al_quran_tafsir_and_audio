import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/settings/settings_page.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/info_controller/info_controller_getx.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/common/tajweed_scripts_composer.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/info_view/info_view.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/models/surah_view_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/tafsir_view/tafsir_view.dart';
import 'package:al_quran_tafsir_and_audio/src/translations/language_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SurahView extends StatefulWidget {
  final int? jumpToAyah;
  final int? ayahStartFrom;
  final String titleToShow;
  final SurahViewInfoModel surahInfo;
  const SurahView({
    super.key,
    required this.surahInfo,
    this.jumpToAyah,
    required this.titleToShow,
    required this.ayahStartFrom,
  });

  @override
  State<SurahView> createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  InfoController infoController = Get.find();
  UniversalController universalController = Get.find();
  LanguageController languageController = Get.find();
  String translationBookName = "";
  late int totalAyah = widget.surahInfo.ayahCount;
  late int initialAyahID = widget.surahInfo.start;

  int tabIndex = 0;

  ScrollController tab1ScrollController = ScrollController();
  ScrollController tab2ScrollController = ScrollController();

  @override
  void initState() {
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleToShow),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(() => SettingsPage());
              setState(() {});
            },
            icon: Icon(
              Icons.settings_rounded,
              size: 18,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(
                alpha: 0.3,
              ),
            ),
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tabIndex == 0
                          ? Colors.green.shade700
                          : Colors.transparent,
                      foregroundColor:
                          tabIndex == 0 ? Colors.white : Colors.green.shade700,
                      iconColor:
                          tabIndex == 0 ? Colors.white : Colors.green.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        tabIndex = 0;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.translate),
                        Gap(10),
                        Text(
                          "Translation",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tabIndex == 1
                          ? Colors.green.shade700
                          : Colors.transparent,
                      foregroundColor:
                          tabIndex == 1 ? Colors.white : Colors.green.shade700,
                      iconColor:
                          tabIndex == 1 ? Colors.white : Colors.green.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        tabIndex = 1;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.book),
                        Gap(10),
                        Text(
                          "Reading",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: tabIndex == 0
                  ? getViewWithTranslation()
                  : getViewWithOutTranslation()),
        ],
      ),
    );
  }

  Widget getViewWithOutTranslation() {
    return Scrollbar(
      controller: tab2ScrollController,
      interactive: true,
      child: ListView.builder(
        controller: tab2ScrollController,
        padding: EdgeInsets.only(
          bottom: 100,
        ),
        itemCount: (totalAyah / 10).ceil(),
        itemBuilder: (context, index) {
          int start = initialAyahID + (index * 10);
          int end = start + 10;
          String ayah10 = "";
          for (int i = start; i < end; i++) {
            ayah10 += Hive.box("quran_db").get(
                "${universalController.quranScriptTypeGetx.value}/$i",
                defaultValue: "");
          }

          return Column(
            children: [
              if (index == 0) getInfoHeaderWidget(),
              if (widget.surahInfo.isStartWithBismillah != true) Gap(10),
              if (widget.surahInfo.isStartWithBismillah == true && index == 0)
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
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text.rich(
                  TextSpan(
                    children: getTajweedTexSpan(
                      ayah10,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: universalController.fontSizeArabic.value,
                  ),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget getViewWithTranslation() {
    return Scrollbar(
      controller: tab1ScrollController,
      interactive: true,
      child: ListView.builder(
        controller: tab1ScrollController,
        padding: EdgeInsets.only(bottom: 100),
        itemCount: totalAyah,
        itemBuilder: (context, index) {
          int currentAyahIndex = initialAyahID + index;

          if (index == 0) {
            return Column(
              children: [
                getInfoHeaderWidget(),
                if (widget.surahInfo.isStartWithBismillah == true)
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
                buildAyahWidget(
                  index: index,
                  currentAyahIndex: currentAyahIndex,
                  infoController: infoController,
                  ayahStartFrom: widget.ayahStartFrom,
                  surahInfo: widget.surahInfo,
                  translationBookName: translationBookName,
                  universalController: universalController,
                ),
              ],
            );
          } else {
            return buildAyahWidget(
              index: index,
              currentAyahIndex: currentAyahIndex,
              infoController: infoController,
              ayahStartFrom: widget.ayahStartFrom,
              surahInfo: widget.surahInfo,
              translationBookName: translationBookName,
              universalController: universalController,
            );
          }
        },
      ),
    );
  }

  Container getInfoHeaderWidget() {
    return Container(
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
                  widget.surahInfo.revelationPlace.capitalizeFirst == "makkah"
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
                "${widget.surahInfo.surahNameSimple.capitalizeFirst} ( ${widget.surahInfo.surahNameArabic} )",
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
                "${widget.surahInfo.revelationPlace.capitalizeFirst} (${widget.surahInfo.revelationPlace == "makkah" ? "مكي" : "مدني"} )",
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
                        "https://api.quran.com/api/v4/chapters/${widget.surahInfo.surahNumber}/info";
                    String languageName =
                        languageController.selectedLanguage.value;
                    log(languageName);
                    Get.to(
                      () => InfoViewOfSurah(
                        surahName:
                            "${widget.surahInfo.surahNameSimple} ( ${widget.surahInfo.surahNameArabic} )",
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
    );
  }
}

Container buildAyahWidget({
  required int index,
  required int currentAyahIndex,
  required InfoController infoController,
  int? ayahStartFrom,
  required UniversalController universalController,
  SurahViewInfoModel? surahInfo,
  required String translationBookName,
  bool showAyahNumber = true,
}) {
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
              if (showAyahNumber)
                Container(
                  height: 30,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.green.shade700.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    (((ayahStartFrom ?? 1) - 1) + (index + 1)).toString(),
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
                  onSelected: (value) {
                    if (value == "tafsir") {
                      Get.to(
                        () => TafsirView(
                          ayahNumber: currentAyahIndex,
                          tafsirBookID: infoController.tafsirBookID.value,
                          fontSize:
                              universalController.fontSizeTranslation.value,
                          surahName: surahInfo?.surahNameSimple,
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: "tafsir",
                        child: ListTile(
                          minTileHeight: 50,
                          leading: Icon(FluentIcons.book_24_filled),
                          title: Text(
                            "Tafsir",
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: "bookmark",
                        child: ListTile(
                          minTileHeight: 50,
                          leading: Icon(Icons.bookmark_rounded),
                          title: Text(
                            "Bookmark",
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: "favorite",
                        child: ListTile(
                          minTileHeight: 50,
                          leading: Icon(
                            Icons.favorite_rounded,
                          ),
                          title: Text(
                            "Favorite",
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: "add_to_group",
                        child: ListTile(
                          minTileHeight: 50,
                          leading: Icon(
                            Icons.add_rounded,
                          ),
                          title: Text(
                            "Add to group",
                          ),
                        ),
                      ),
                    ];
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
