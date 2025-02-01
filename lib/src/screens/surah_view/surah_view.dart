import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/core/audio/widget_audio_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/functions/audio_tracking/audio_tracting.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/models/quran_surah_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/audio_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/settings/settings_page.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/info_controller/info_controller_getx.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/common/tajweed_scripts_composer.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/info_view/info_view.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/tafsir_view/tafsir_view.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/notes/take_note_page.dart';
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
  final String? titleToShow;
  final int ayahStart;
  final int ayahEnd;
  const SurahView({
    super.key,
    this.jumpToAyah,
    required this.titleToShow,
    required this.ayahStart,
    required this.ayahEnd,
  });

  @override
  State<SurahView> createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  InfoController infoController = Get.find();
  UniversalController universalController = Get.find();
  LanguageController languageController = Get.find();
  String translationBookName = '';
  late int totalAyah = widget.ayahEnd - widget.ayahStart;

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
    for (int i = 0; i < totalAyah; i++) {
      items.add(GlobalKey());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleToShow ?? 'Surah View'),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(() => const SettingsPage());
              setState(() {});
            },
            icon: const Icon(
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
                          shape: const RoundedRectangleBorder(
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.translate),
                            Gap(10),
                            Text(
                              'Translation',
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
                          shape: const RoundedRectangleBorder(
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.book),
                            Gap(10),
                            Text(
                              'Reading',
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
                  getViewWithTranslation(
                      widget.ayahStart, widget.ayahEnd, tab1ScrollController),
                  getViewWithOutTranslation(
                      widget.ayahStart, widget.ayahEnd, tab2ScrollController),
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

  List<List<int>> divideAyahsByParts(initialAyahID, endAyahID) {
    List<List<int>> toReturn = [];
    List<int> listToInsert = [];
    for (int i = initialAyahID; i < endAyahID; i++) {
      int surahNumber = getSurahNumberFormAyahID(i);
      QuranSurahInfoModel surahInfo =
          QuranSurahInfoModel.fromMap(allChaptersInfo[surahNumber - 1]);
      int ayahNumberInSurah = getAyahNumberInSurah(i, surahInfo);
      if (ayahNumberInSurah == 0) {
        if (listToInsert.isNotEmpty) {
          toReturn.add(listToInsert.toSet().toList());
        }
        listToInsert.clear();
      } else {
        if (ayahNumberInSurah % 10 == 0) {
          if (listToInsert.isNotEmpty) {
            toReturn.add(listToInsert.toSet().toList());
          }
          listToInsert.clear();
        }
      }
      listToInsert.add(i);
    }
    if (listToInsert.isNotEmpty) {
      toReturn.add(listToInsert);
    }
    return toReturn;
  }

  Widget getViewWithOutTranslation(
      int initialAyahID, int endAyahID, ScrollController tab2ScrollController) {
    List<List<int>> divination = divideAyahsByParts(initialAyahID, endAyahID);

    return Scrollbar(
      controller: tab2ScrollController,
      interactive: true,
      thickness: 10,
      radius: const Radius.circular(10),
      child: ListView.builder(
        controller: tab2ScrollController,
        padding: const EdgeInsets.only(
          bottom: 100,
          left: 5,
          right: 5,
        ),
        itemCount: divination.length,
        itemBuilder: (context, index) {
          List<int> currentAyahs = divination[index];
          int currentAyahIndex = currentAyahs[0];
          int surahNumber = getSurahNumberFormAyahID(currentAyahIndex);
          QuranSurahInfoModel surahInfo =
              QuranSurahInfoModel.fromMap(allChaptersInfo[surahNumber - 1]);
          int ayahNumberInSurah =
              getAyahNumberInSurah(currentAyahIndex, surahInfo);

          String ayah10 = '';
          for (int i in currentAyahs) {
            ayah10 += Hive.box('quran_db').get(
                '${universalController.quranScriptTypeGetx.value}/${i + 1}',
                defaultValue: '');
          }

          return Column(
            children: [
              if (ayahNumberInSurah == 0) const Gap(15),
              if (ayahNumberInSurah == 0)
                getInfoHeaderWidget(surahInfo, languageController),
              if (surahInfo.bismillahPre != true) const Gap(10),
              if (surahInfo.bismillahPre == true && index == 0)
                Padding(
                  padding: const EdgeInsets.all(10),
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

  Widget getViewWithTranslation(
      int initialAyahID, int endAyahID, ScrollController tab1ScrollController) {
    return Scrollbar(
      controller: tab1ScrollController,
      interactive: true,
      thickness: 10,
      radius: const Radius.circular(10),
      child: ListView.builder(
        controller: tab1ScrollController,
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: totalAyah,
        itemBuilder: (context, index) {
          int currentAyahIndex = initialAyahID + index;
          int surahNumber = getSurahNumberFormAyahID(currentAyahIndex);
          QuranSurahInfoModel surahInfo =
              QuranSurahInfoModel.fromMap(allChaptersInfo[surahNumber - 1]);
          int ayahNumberInSurah =
              getAyahNumberInSurah(currentAyahIndex, surahInfo);

          if (ayahNumberInSurah == 0) {
            return Column(
              children: [
                const Gap(10),
                getInfoHeaderWidget(surahInfo, languageController),
                if (surahInfo.bismillahPre == true)
                  Padding(
                    padding: const EdgeInsets.all(10),
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
                  ayahStartFrom: ayahNumberInSurah,
                  surahInfo: surahInfo,
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
              ayahStartFrom: ayahNumberInSurah,
              surahInfo: surahInfo,
              translationBookName: translationBookName,
              universalController: universalController,
            );
          }
        },
      ),
    );
  }
}

int getSurahNumberFormAyahID(int ayahID) {
  int totalAyah = 0;
  int surahNumber = 1;
  for (int i = 0; i < ayahCount.length; i++) {
    totalAyah += ayahCount[i];
    if (totalAyah > ayahID) {
      surahNumber = i + 1;
      break;
    }
  }
  return surahNumber;
}

int getAyahNumberInSurah(int ayahID, QuranSurahInfoModel surahInfo) {
  int lastSumOfAyah = 0;
  for (int i = 0; i < surahInfo.id; i++) {
    lastSumOfAyah += ayahCount[i];
  }
  int toReturn = lastSumOfAyah - ayahID;
  return surahInfo.versesCount - toReturn;
}

Container getInfoHeaderWidget(
    QuranSurahInfoModel surahInfo, LanguageController languageController) {
  return Container(
    margin: const EdgeInsets.all(5),
    padding: const EdgeInsets.all(5),
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
                surahInfo.revelationPlace.capitalizeFirst == 'makkah'
                    ? 'assets/img/makkah.jpg'
                    : 'assets/img/madina.jpeg',
              ),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const Gap(10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Surah Name',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
              ),
            ),
            Text(
              '${surahInfo.nameSimple.capitalizeFirst} ( ${surahInfo.nameArabic} )',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Revelation Place',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
              ),
            ),
            Text(
              "${surahInfo.revelationPlace.capitalizeFirst} (${surahInfo.revelationPlace == "makkah" ? "مكي" : "مدني"} )",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),
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
                      'https://api.quran.com/api/v4/chapters/${surahInfo.id}/info';
                  String languageName =
                      languageController.selectedLanguage.value;
                  log(languageName);
                  Get.to(
                    () => InfoViewOfSurah(
                      surahName:
                          '${surahInfo.nameSimple} ( ${surahInfo.nameArabic} )',
                      infoURL: url,
                      languageName: languageName,
                    ),
                  );
                },
                icon: const Icon(
                  FluentIcons.info_24_filled,
                ),
              ),
            ),
            SizedBox(
              height: 35,
              width: 35,
              child: getPlayButton(
                surahInfo.id - 1,
                audioController,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Container buildAyahWidget({
  GlobalKey? key,
  required int index,
  required int currentAyahIndex,
  required InfoController infoController,
  required int ayahStartFrom,
  required UniversalController universalController,
  QuranSurahInfoModel? surahInfo,
  required String translationBookName,
  bool showAyahNumber = true,
}) {
  final collectionBox = Hive.box('collections_db');
  String ayahKey = '${surahInfo?.id}:${index + 1}';
  return Container(
    key: key,
    width: double.infinity,
    margin: const EdgeInsets.all(5),
    padding: const EdgeInsets.all(5),
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
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.green.shade700.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    (ayahStartFrom + 1).toString(),
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: 50,
                height: 30,
                child: getPlayButton(
                  currentAyahIndex,
                  audioController,
                  relatedWithAyah: true,
                  surahNumber: (surahInfo?.id ?? 1) - 1,
                  indexOfAyahInSurah: index,
                ),
              ),
              const Gap(10),
              getPopUpMenu(currentAyahIndex, infoController,
                  universalController, surahInfo, collectionBox, ayahKey),
            ],
          ),
        ),
        const Gap(10),
        Align(
          alignment: Alignment.topRight,
          child: Obx(
            () => Text.rich(
              TextSpan(
                children: getTajweedTexSpan(
                  Hive.box('quran_db').get(
                    'uthmani_tajweed/${currentAyahIndex + 1}',
                    defaultValue: '',
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
        const Divider(),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Translation book :\n$translationBookName',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        const Gap(5),
        Align(
          alignment: Alignment.topLeft,
          child: Obx(
            () => Text(
              Hive.box('translation_db').get(
                '${infoController.bookIDTranslation.value}/$currentAyahIndex',
                defaultValue: '',
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
    QuranSurahInfoModel? surahInfo,
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
        if (value == 'tafsir') {
          Get.to(
            () => TafsirView(
              ayahNumber: currentAyahIndex,
              tafsirBookID: infoController.tafsirBookID.value,
              fontSize: universalController.fontSizeTranslation.value,
              surahName: surahInfo?.nameSimple,
            ),
          );
        } else if (value == 'bookmark' || value == 'favorite') {
          CollectionInfoModel? collectionInfoModel =
              getCollectionData(collectionBox, value);
          if (collectionInfoModel?.ayahs?.contains(ayahKey) ?? false) {
            collectionInfoModel?.ayahs!.remove(ayahKey);
            toastification.show(
                title: Text('Removed from ${value.capitalizeFirst}'),
                autoCloseDuration: const Duration(seconds: 2),
                type: ToastificationType.success);
          } else {
            collectionInfoModel?.ayahs!.add(ayahKey);
            toastification.show(
                title: Text('Added to ${value.capitalizeFirst}'),
                autoCloseDuration: const Duration(seconds: 2),
                type: ToastificationType.success);
          }
          if (collectionInfoModel != null) {
            collectionBox.put(value, collectionInfoModel.toJson());
          }
        } else if (value == 'add_to_group') {
          showAddToCollectGroupDialog(collectionBox, ayahKey);
        } else if (value.contains('share')) {
          String text = Hive.box('quran_db')
              .get(
                'uthmani_simple/${currentAyahIndex + 1}',
                defaultValue: '',
              )
              .toString();

          String trans = Hive.box('translation_db').get(
            '${infoController.bookIDTranslation.value}/$currentAyahIndex',
            defaultValue: '',
          );
          String subject =
              "${surahInfo?.nameSimple ?? ""} ( ${surahInfo?.nameArabic ?? ""} ) - ${currentAyahIndex + 1}";
          if (value == 'share') {
            Share.share(
              '$text\nTranslation:\n$trans\n\n$subject',
              subject: subject,
            );
          } else {
            String tafsir = await getTafsirText(
                infoController.tafsirBookID.value, currentAyahIndex);
            Share.share(
              '$text\nTranslation:\n$trans\nTafsir:\n$tafsir\n\n$subject',
              subject: subject,
            );
          }
        } else if (value == 'note') {
          Get.to(
            () => TakeNotePage(
              surahNumber: surahInfo!.id,
              ayahNumber: currentAyahIndex,
            ),
          );
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 'tafsir',
            child: ListTile(
              minTileHeight: 50,
              leading: Icon(FluentIcons.book_24_filled),
              title: Text(
                'Tafsir',
              ),
            ),
          ),
          const PopupMenuItem(
            value: 'note',
            child: ListTile(
              minTileHeight: 50,
              leading: Icon(
                FluentIcons.notepad_24_filled,
              ),
              title: Text(
                'Take Note',
              ),
            ),
          ),
          PopupMenuItem(
            value: 'bookmark',
            child: ListTile(
              minTileHeight: 50,
              leading: Icon(
                getCollectionData(collectionBox, 'bookmark')
                            ?.ayahs!
                            .contains(ayahKey) ??
                        false
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_rounded,
                color: getCollectionData(collectionBox, 'bookmark')
                            ?.ayahs!
                            .contains(ayahKey) ??
                        false
                    ? Colors.green
                    : Colors.grey.withValues(alpha: 0.5),
              ),
              title: const Text(
                'Bookmark',
              ),
            ),
          ),
          PopupMenuItem(
            value: 'favorite',
            child: ListTile(
              minTileHeight: 50,
              leading: Icon(
                getCollectionData(collectionBox, 'favorite')
                            ?.ayahs!
                            .contains(ayahKey) ??
                        false
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: getCollectionData(collectionBox, 'favorite')
                            ?.ayahs!
                            .contains(ayahKey) ??
                        false
                    ? Colors.green
                    : Colors.grey.withValues(alpha: 0.5),
              ),
              title: const Text(
                'Favorite',
              ),
            ),
          ),
          const PopupMenuItem(
            value: 'add_to_group',
            child: ListTile(
              minTileHeight: 50,
              leading: Icon(
                Icons.add_rounded,
              ),
              title: Text(
                'Add to group',
              ),
            ),
          ),
          const PopupMenuItem(
            value: 'share',
            child: ListTile(
              minTileHeight: 50,
              leading: Icon(
                Icons.share,
              ),
              title: Text(
                'Share',
              ),
            ),
          ),
          const PopupMenuItem(
            value: 'share_with_tafsir',
            child: ListTile(
              minTileHeight: 50,
              leading: Icon(
                Icons.share,
              ),
              title: Text(
                'Share With Tafsir',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add to Group',
                style: TextStyle(fontSize: 20),
              ),
              const Divider(),
              if (collectionBox.keys.isEmpty)
                const Center(
                  child: Text(
                    'There are no existing groups\n Please create one',
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
                                'Already exists in ${value.capitalizeFirst}',
                              ),
                              autoCloseDuration: const Duration(seconds: 2),
                              type: ToastificationType.success);
                          return;
                        } else {
                          collectionInfoModel?.ayahs!.add(ayahKey);
                          toastification.show(
                              title: Text('Added to ${value.capitalizeFirst}'),
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
