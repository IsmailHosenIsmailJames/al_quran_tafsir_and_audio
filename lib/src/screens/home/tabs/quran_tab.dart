import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/models/juz_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/models/quran_surah_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/models/surah_view_info_model.dart';
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
  @override
  Widget build(BuildContext context) {
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
                    width: width * 0.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: quranTabIndex == 0
                            ? Colors.green.shade700
                            : Colors.transparent,
                        foregroundColor: quranTabIndex == 0
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
                        quranTabIndex = 0;
                        pageController.jumpToPage(0);
                      },
                      child: Text(
                        "Surah",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: quranTabIndex == 1
                            ? Colors.green.shade700
                            : Colors.transparent,
                        foregroundColor: quranTabIndex == 1
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
                        quranTabIndex = 1;
                        pageController.jumpToPage(1);
                      },
                      child: Text(
                        "Juz",
                        style: TextStyle(
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
            ListView.builder(
              padding: EdgeInsets.only(bottom: 100, top: 5),
              itemCount: 114,
              itemBuilder: (context, index) {
                QuranSurahInfoModel quranSurahInfoModel =
                    QuranSurahInfoModel.fromMap(allChaptersInfo[index]);
                return Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
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
                          ayahStartFrom: 1,
                          surahInfo: SurahViewInfoModel(
                            surahNumber: quranSurahInfoModel.id,
                            start: start,
                            end: quranSurahInfoModel.versesCount,
                            ayahCount: quranSurahInfoModel.versesCount,
                            surahNameArabic: quranSurahInfoModel.nameArabic,
                            surahNameSimple: quranSurahInfoModel.nameSimple,
                            revelationPlace:
                                quranSurahInfoModel.revelationPlace,
                            isStartWithBismillah:
                                quranSurahInfoModel.bismillahPre,
                          ),
                          titleToShow: quranSurahInfoModel.nameSimple,
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Gap(10),
                        Text(
                          quranSurahInfoModel.nameSimple,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              quranSurahInfoModel.nameArabic,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${quranSurahInfoModel.versesCount} ayahs",
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
            ListView.builder(
              padding: EdgeInsets.only(bottom: 100),
              itemCount: 30,
              itemBuilder: (context, index) {
                JuzInfoModel juzInfoModel =
                    JuzInfoModel.fromMap(allJuzInfo[index]);
                return Column(
                  children: [
                    Container(
                      height: 55,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(5),
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
                                "${juzInfoModel.juzNumber}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Gap(10),
                            getJuzName(
                              juzInfoModel,
                              TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${surahCountInJuz(juzInfoModel)} surahs",
                                ),
                                Text(
                                  "${getAyahCountJuz(juzInfoModel)} ayahs",
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
                          ? (60 * juzInfoModel.verseMapping.length).toDouble() +
                              20
                          : 0,
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.only(left: 18, right: 18),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(7),
                          bottomRight: Radius.circular(7),
                        ),
                        color: Colors.grey.withValues(alpha: 0.1),
                      ),
                      child: Column(
                        children: List.generate(
                          juzInfoModel.verseMapping.length,
                          (index) {
                            final key =
                                juzInfoModel.verseMapping.keys.toList()[index];
                            String value = juzInfoModel.verseMapping[key]!;
                            int start = int.parse(value.split("-")[0]);
                            int end = int.parse(value.split("-")[1]);
                            int surahNumber = int.parse(key) - 1;

                            QuranSurahInfoModel quranSurahInfoModel =
                                QuranSurahInfoModel.fromMap(
                              allChaptersInfo[surahNumber],
                            );

                            return Container(
                              height: 55,
                              margin: EdgeInsets.all(2.5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.green.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                onPressed: () {
                                  int startAyahNumber = 0;
                                  for (int x = 0; x < surahNumber; x++) {
                                    startAyahNumber += ayahCount[x];
                                  }
                                  Get.to(
                                    () => SurahView(
                                      ayahStartFrom: start,
                                      surahInfo: SurahViewInfoModel(
                                          surahNumber: quranSurahInfoModel.id,
                                          start: startAyahNumber + start - 1,
                                          end: startAyahNumber + end - 1,
                                          ayahCount: (end - start) + 1,
                                          surahNameArabic:
                                              quranSurahInfoModel.nameArabic,
                                          surahNameSimple:
                                              quranSurahInfoModel.nameSimple,
                                          revelationPlace: quranSurahInfoModel
                                              .revelationPlace,
                                          isStartWithBismillah:
                                              quranSurahInfoModel.bismillahPre),
                                      titleToShow:
                                          quranSurahInfoModel.nameSimple,
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
                                          quranSurahInfoModel.nameSimple,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Gap(5),
                                        if (ayahCount[int.parse(key) - 1] !=
                                            ((end - start) + 1))
                                          Text("( $value )")
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          quranSurahInfoModel.nameArabic,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${(end - start) + 1} ayahs",
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
          ],
        )),
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
      firstSurahInfo.nameSimple,
      style: textStyle,
    );
  } else {
    return Row(children: [
      Text(firstSurahInfo.nameSimple, style: textStyle),
      Gap(2),
      Text(" - "),
      Gap(2),
      Text(
        lastSurahInfo.nameSimple,
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
