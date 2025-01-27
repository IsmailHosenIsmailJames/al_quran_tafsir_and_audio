import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/core/audio/widget_audio_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/functions/audio_tracking/audio_tracting.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/audio_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_model.dart';
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
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';

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

  ScrollController tab1ScrollController = ScrollController();
  ScrollController tab2ScrollController = ScrollController();

  late PageController pageController =
      PageController(initialPage: universalController.surahViewTabIndex.value);

  List<GlobalKey> items = [];

  @override
  void initState() {
    for (Map translation in allTranslationLanguage) {
      if ("${translation['id']}" == infoController.bookIDTranslation.value) {
        translationBookName =
            "${translation['name']} by ${translation['author_name']}";
      }
    }
    int ayahCount = widget.surahInfo.ayahCount;
    for (int i = 0; i < ayahCount; i++) {
      items.add(GlobalKey());
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
            child: Obx(
              () {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width * 0.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              universalController.surahViewTabIndex.value == 0
                                  ? Colors.green.shade700
                                  : Colors.transparent,
                          foregroundColor:
                              universalController.surahViewTabIndex.value == 0
                                  ? Colors.white
                                  : Colors.green.shade700,
                          iconColor:
                              universalController.surahViewTabIndex.value == 0
                                  ? Colors.white
                                  : Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                        ),
                        onPressed: () {
                          universalController.surahViewTabIndex.value = 0;
                          pageController.jumpToPage(0);
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
                          backgroundColor:
                              universalController.surahViewTabIndex.value == 1
                                  ? Colors.green.shade700
                                  : Colors.transparent,
                          foregroundColor:
                              universalController.surahViewTabIndex.value == 1
                                  ? Colors.white
                                  : Colors.green.shade700,
                          iconColor:
                              universalController.surahViewTabIndex.value == 1
                                  ? Colors.white
                                  : Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                          ),
                        ),
                        onPressed: () {
                          universalController.surahViewTabIndex.value = 1;
                          pageController.jumpToPage(1);
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
                );
              },
            ),
          ),
          Expanded(
              child: Stack(
            children: [
              PageView(
                controller: pageController,
                onPageChanged: (value) =>
                    {universalController.surahViewTabIndex.value = value},
                children: [
                  getViewWithTranslation(),
                  getViewWithOutTranslation()
                ],
              ),
              Obx(
                () => Container(
                  child: (audioController.isPlaying.value == true ||
                          audioController.isReadyToControl.value == true)
                      ? WidgetAudioController(
                          showSurahNumber: false,
                          showQuranAyahMode: true,
                          surahNumber: audioController.currentPlayingAyah.value,
                        )
                      : null,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget getViewWithOutTranslation() {
    return Scrollbar(
      controller: tab2ScrollController,
      interactive: true,
      thickness: 10,
      radius: Radius.circular(10),
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
      thickness: 10,
      radius: Radius.circular(10),
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
                  key: items[index],
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
              key: items[index],
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
                child: getPlayButton(
                  widget.surahInfo.surahNumber - 1,
                  audioController,
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
  GlobalKey? key,
  required int index,
  required int currentAyahIndex,
  required InfoController infoController,
  int? ayahStartFrom,
  required UniversalController universalController,
  SurahViewInfoModel? surahInfo,
  required String translationBookName,
  bool showAyahNumber = true,
}) {
  final collectionBox = Hive.box("collections_db");
  String ayahKey = "${surahInfo?.surahNumber}:${index + 1}";
  return Container(
    key: key,
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
                width: 50,
                height: 30,
                child: getPlayButton(
                  currentAyahIndex,
                  audioController,
                  relatedWithAyah: true,
                  surahNumber: (surahInfo?.surahNumber ?? 1) - 1,
                  indexOfAyahInSurah: index,
                ),
              ),
              Gap(10),
              getPopUpMenu(currentAyahIndex, infoController,
                  universalController, surahInfo, collectionBox, ayahKey),
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

SizedBox getPopUpMenu(
    int currentAyahIndex,
    InfoController infoController,
    UniversalController universalController,
    SurahViewInfoModel? surahInfo,
    Box<dynamic> collectionBox,
    String ayahKey) {
  return SizedBox(
    height: 30,
    width: 30,
    child: PopupMenuButton(
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.grey.shade600.withValues(alpha: 0.3),
        iconSize: 18,
      ),
      onSelected: (value) async {
        if (value == "tafsir") {
          Get.to(
            () => TafsirView(
              ayahNumber: currentAyahIndex,
              tafsirBookID: infoController.tafsirBookID.value,
              fontSize: universalController.fontSizeTranslation.value,
              surahName: surahInfo?.surahNameSimple,
            ),
          );
        } else if (value == "bookmark" || value == "favorite") {
          CollectionInfoModel? collectionInfoModel =
              getCollectionData(collectionBox, value);
          if (collectionInfoModel?.ayahs?.contains(ayahKey) ?? false) {
            collectionInfoModel?.ayahs!.remove(ayahKey);
            toastification.show(
                title: Text("Removed from ${value.capitalizeFirst}"),
                autoCloseDuration: const Duration(seconds: 2),
                type: ToastificationType.success);
          } else {
            collectionInfoModel?.ayahs!.add(ayahKey);
            toastification.show(
                title: Text("Added to ${value.capitalizeFirst}"),
                autoCloseDuration: const Duration(seconds: 2),
                type: ToastificationType.success);
          }
          if (collectionInfoModel != null) {
            collectionBox.put(value, collectionInfoModel.toJson());
          }
        } else if (value == "add_to_group") {
          showAddToCollectGroupDialog(collectionBox, ayahKey);
        } else if (value.contains("share")) {
          String text = Hive.box("quran_db")
              .get(
                "uthmani_simple/${currentAyahIndex + 1}",
                defaultValue: "",
              )
              .toString();

          String trans = Hive.box("translation_db").get(
            "${infoController.bookIDTranslation.value}/$currentAyahIndex",
            defaultValue: "",
          );
          String subject =
              "${surahInfo?.surahNameSimple ?? ""} ( ${surahInfo?.surahNameArabic ?? ""} ) - ${currentAyahIndex + 1}";
          if (value == "share") {
            Share.share(
              "$text\nTranslation:\n$trans\n\n$subject",
              subject: subject,
            );
          } else {
            String tafsir = await getTafsirText(
                infoController.tafsirBookID.value, currentAyahIndex);
            Share.share(
              "$text\nTranslation:\n$trans\nTafsir:\n$tafsir\n\n$subject",
              subject: subject,
            );
          }
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
              leading: Icon(
                getCollectionData(collectionBox, "bookmark")
                            ?.ayahs!
                            .contains(ayahKey) ??
                        false
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_rounded,
                color: getCollectionData(collectionBox, "bookmark")
                            ?.ayahs!
                            .contains(ayahKey) ??
                        false
                    ? Colors.green
                    : Colors.grey,
              ),
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
                getCollectionData(collectionBox, "favorite")
                            ?.ayahs!
                            .contains(ayahKey) ??
                        false
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: getCollectionData(collectionBox, "favorite")
                            ?.ayahs!
                            .contains(ayahKey) ??
                        false
                    ? Colors.green
                    : Colors.grey,
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
          PopupMenuItem(
            value: "share",
            child: ListTile(
              minTileHeight: 50,
              leading: Icon(
                Icons.share,
              ),
              title: Text(
                "Share",
              ),
            ),
          ),
          PopupMenuItem(
            value: "share_with_tafsir",
            child: ListTile(
              minTileHeight: 50,
              leading: Icon(
                Icons.share,
              ),
              title: Text(
                "Share With Tafsir",
              ),
            ),
          ),
        ];
      },
    ),
  );
}

Future<dynamic> showAddToCollectGroupDialog(
    Box<dynamic> collectionBox, String ayahKey) {
  return showDialog(
    context: Get.context!,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add to Group",
                style: TextStyle(fontSize: 20),
              ),
              Divider(),
              if (collectionBox.keys.isEmpty)
                Center(
                  child: Text(
                    "There are no existing groups\n Please create one",
                    textAlign: TextAlign.center,
                  ),
                ),
              ...List.generate(
                collectionBox.keys.length,
                (index) {
                  return ListTile(
                      minTileHeight: 50,
                      onTap: () {
                        String value = collectionBox.keys.elementAt(index);
                        CollectionInfoModel? collectionInfoModel =
                            getCollectionData(collectionBox, value);
                        if (collectionInfoModel?.ayahs?.contains(ayahKey) ??
                            false) {
                          toastification.show(
                              title: Text(
                                "Already exists in ${value.capitalizeFirst}",
                              ),
                              autoCloseDuration: const Duration(seconds: 2),
                              type: ToastificationType.success);
                          return;
                        } else {
                          collectionInfoModel?.ayahs!.add(ayahKey);
                          toastification.show(
                              title: Text("Added to ${value.capitalizeFirst}"),
                              autoCloseDuration: const Duration(seconds: 2),
                              type: ToastificationType.success);
                        }
                        if (collectionInfoModel != null) {
                          collectionBox.put(
                              value, collectionInfoModel.toJson());
                        }
                        Navigator.pop(context);
                      },
                      title: Text(
                        collectionBox.keys
                            .elementAt(index)
                            .toString()
                            .capitalizeFirst,
                      ));
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

CollectionInfoModel? getCollectionData(
    Box<dynamic> collectionBox, String value) {
  CollectionInfoModel? collectionInfoModel;
  final previousData = collectionBox.get(value, defaultValue: null);
  if (previousData != null) {
    collectionInfoModel = CollectionInfoModel.fromJson(previousData);
  }
  collectionInfoModel ??= CollectionInfoModel(
    id: value,
    isPublicResources: false,
    name: value.capitalizeFirst,
  );
  collectionInfoModel.ayahs ??= [];
  return collectionInfoModel;
}
