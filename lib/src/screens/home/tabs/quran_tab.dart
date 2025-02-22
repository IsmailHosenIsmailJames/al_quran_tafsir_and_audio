import 'package:al_quran_tafsir_and_audio/src/functions/get_native_surah_meaning.dart';
import 'package:al_quran_tafsir_and_audio/src/functions/get_native_surah_name.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/models/juz_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/models/quran_surah_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/surah_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class QuranTab extends StatefulWidget {
  const QuranTab({super.key});

  @override
  State<QuranTab> createState() => _QuranTabState();
}

class _QuranTabState extends State<QuranTab> {
  List<bool> isExpanded = List.generate(30, (index) => false);
  final UniversalController universalController = Get.find();
  late PageController pageController = PageController(
    initialPage: universalController.quranTabIndex.value,
  );
  ScrollController scrollControllerTab1 = ScrollController();
  ScrollController scrollControllerTab2 = ScrollController();
  ScrollController scrollControllerTab3 = ScrollController();
  @override
  Widget build(BuildContext context) {
    String local = Get.locale?.languageCode ?? 'en';
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(
              alpha: 0.2,
            ),
          ),
          height: 30,
          child: Obx(
            () {
              int quranTabIndex = universalController.quranTabIndex.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 0.3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: quranTabIndex == 0
                            ? Colors.green.shade700
                            : Colors.transparent,
                        foregroundColor: quranTabIndex == 0
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
                        quranTabIndex = 0;
                        pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear,
                        );
                      },
                      child: Text(
                        'Surah'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: quranTabIndex == 1
                            ? Colors.green.shade700
                            : Colors.transparent,
                        foregroundColor: quranTabIndex == 1
                            ? Colors.white
                            : Colors.green.shade700,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: () {
                        quranTabIndex = 1;
                        pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear,
                        );
                      },
                      child: Text(
                        'Juz'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: quranTabIndex == 2
                            ? Colors.green.shade700
                            : Colors.transparent,
                        foregroundColor: quranTabIndex == 2
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
                        quranTabIndex = 2;
                        pageController.animateToPage(
                          2,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear,
                        );
                      },
                      child: Text(
                        'Pages'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (value) =>
                universalController.quranTabIndex.value = value,
            children: [
              Scrollbar(
                controller: scrollControllerTab1,
                interactive: true,
                thickness: 7,
                radius: const Radius.circular(10),
                child: ListView.builder(
                  controller: scrollControllerTab1,
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: 114,
                  itemBuilder: (context, index) {
                    QuranSurahInfoModel quranSurahInfoModel =
                        QuranSurahInfoModel.fromMap(allChaptersInfo[index]);
                    return Container(
                      width: double.infinity,
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.grey.withValues(alpha: 0.1),
                      ),
                      child: TextButton(
                        onPressed: () {
                          int start = 0;
                          for (int i = 0; i < index; i++) {
                            start += ayahCount[i];
                          }
                          Get.to(
                            () => SurahView(
                              ayahStart: start,
                              titleToShow: getSurahNativeName(
                                  local, quranSurahInfoModel.id - 1),
                              ayahEnd: start + quranSurahInfoModel.versesCount,
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Gap(10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getSurahNativeName(
                                    local,
                                    index,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  getSurahNativeMeaning(
                                    local,
                                    index,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  quranSurahInfoModel.nameArabic,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${quranSurahInfoModel.versesCount} ${'ayahs'.tr}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Scrollbar(
                controller: scrollControllerTab2,
                interactive: true,
                thickness: 7,
                radius: const Radius.circular(10),
                child: ListView.builder(
                  controller: scrollControllerTab2,
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    JuzInfoModel juzInfoModel =
                        JuzInfoModel.fromMap(allJuzInfo[index]);
                    return Column(
                      children: [
                        Container(
                          height: 55,
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.grey.withValues(alpha: 0.1),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isExpanded[index] = !isExpanded[index];
                              });
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Text(
                                    '${juzInfoModel.juzNumber}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                getJuzName(
                                  juzInfoModel,
                                  const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${surahCountInJuz(juzInfoModel)} ${'Surah'.tr}',
                                    ),
                                    Text(
                                      '${getAyahCountJuz(juzInfoModel)} ${'ayahs'.tr}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          height: isExpanded[index] == true
                              ? (60 * juzInfoModel.verseMapping.length)
                                      .toDouble() +
                                  20
                              : 0,
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(left: 18, right: 18),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(7),
                              bottomRight: Radius.circular(7),
                            ),
                            color: Colors.grey.withValues(alpha: 0.1),
                          ),
                          child: Column(
                            children: List.generate(
                              juzInfoModel.verseMapping.length,
                              (index) {
                                final key = juzInfoModel.verseMapping.keys
                                    .toList()[index];
                                String value = juzInfoModel.verseMapping[key]!;
                                int start = int.parse(value.split('-')[0]) - 1;
                                int end = int.parse(value.split('-')[1]);
                                int surahNumber = int.parse(key) - 1;

                                QuranSurahInfoModel quranSurahInfoModel =
                                    QuranSurahInfoModel.fromMap(
                                  allChaptersInfo[surahNumber],
                                );

                                return Container(
                                  margin: const EdgeInsets.all(2.5),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.green.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                    ),
                                    onPressed: () {
                                      int startAyahOfSurah = 0;
                                      for (int x = 0; x < surahNumber; x++) {
                                        startAyahOfSurah += ayahCount[x];
                                      }
                                      Get.to(
                                        () => SurahView(
                                          ayahStart: startAyahOfSurah + start,
                                          titleToShow: getSurahNativeName(local,
                                              quranSurahInfoModel.id - 1),
                                          ayahEnd: startAyahOfSurah + end,
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              getSurahNativeName(
                                                Get.locale?.languageCode ??
                                                    'en',
                                                quranSurahInfoModel.id - 1,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Gap(5),
                                            if (ayahCount[int.parse(key) - 1] !=
                                                ((end - start) + 1))
                                              Text('( $value )')
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              quranSurahInfoModel.nameArabic,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${(end - start) + 1} ${'ayahs'.tr}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Scrollbar(
                controller: scrollControllerTab3,
                interactive: true,
                thickness: 7,
                radius: const Radius.circular(10),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  controller: scrollControllerTab3,
                  itemCount: pagesInfo.length,
                  itemBuilder: (context, index) {
                    QuranSurahInfoModel quranSurahInfoModel =
                        QuranSurahInfoModel.fromMap(
                      allChaptersInfo[pagesInfo[index]['sn']! - 1],
                    );
                    return Container(
                      width: double.infinity,
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.grey.withValues(alpha: 0.1),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Get.to(
                            () => SurahView(
                              ayahStart: pagesInfo[index]['s']! - 1,
                              ayahEnd: pagesInfo[index]['e']!,
                              titleToShow: getSurahNativeName(
                                  local, quranSurahInfoModel.id - 1),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Gap(10),
                            Text(
                              getSurahNativeName(
                                  local, quranSurahInfoModel.id - 1),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  quranSurahInfoModel.nameArabic,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${pagesInfo[index]['e']! - pagesInfo[index]['s']! + 1} ${'ayahs'.tr}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

Widget getJuzName(JuzInfoModel juzInfoModel, TextStyle textStyle) {
  int firstSurahNumber = int.parse(juzInfoModel.verseMapping.keys.first) - 1;
  int lastSurahNumber = int.parse(juzInfoModel.verseMapping.keys.last) - 1;

  QuranSurahInfoModel firstSurahInfo =
      QuranSurahInfoModel.fromMap(allChaptersInfo[firstSurahNumber]);
  QuranSurahInfoModel lastSurahInfo =
      QuranSurahInfoModel.fromMap(allChaptersInfo[lastSurahNumber]);

  if (firstSurahNumber == lastSurahNumber) {
    return Text(
      getSurahNativeName(
        Get.locale?.languageCode ?? 'en',
        firstSurahInfo.id - 1,
      ),
      style: textStyle,
    );
  } else {
    return Row(children: [
      Text(
          getSurahNativeName(
            Get.locale?.languageCode ?? 'en',
            firstSurahInfo.id - 1,
          ),
          style: textStyle),
      const Gap(2),
      const Text(' - '),
      const Gap(2),
      Text(
        getSurahNativeName(
          Get.locale?.languageCode ?? 'en',
          lastSurahInfo.id - 1,
        ),
        style: textStyle,
      )
    ]);
  }
}

int surahCountInJuz(JuzInfoModel juzInfoModel) {
  return juzInfoModel.verseMapping.length;
}

int getAyahCountJuz(JuzInfoModel juzInfoModel) {
  return juzInfoModel.lastVerseId - juzInfoModel.firstVerseId;
}
