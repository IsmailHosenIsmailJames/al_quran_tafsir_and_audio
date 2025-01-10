import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/models/juz_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/models/quran_surah_info_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class QuranTab extends StatefulWidget {
  const QuranTab({super.key});

  @override
  State<QuranTab> createState() => _QuranTabState();
}

class _QuranTabState extends State<QuranTab> {
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
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
                    backgroundColor: tabIndex == 1
                        ? Colors.green.shade700
                        : Colors.transparent,
                    foregroundColor:
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
                  child: Text(
                    "Juz",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: tabIndex == 0
              ? ListView.builder(
                  padding: EdgeInsets.only(bottom: 100),
                  itemCount: 114,
                  itemBuilder: (context, index) {
                    QuranSurahInfoModel quranSurahInfoModel =
                        QuranSurahInfoModel.fromMap(allChaptersInfo[index]);
                    return Container(
                      height: 55,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                      child: TextButton(
                        onPressed: () {},
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
                                    fontSize: 16,
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
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: 100),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    JuzInfoModel juzInfoModel =
                        JuzInfoModel.fromMap(allJuzInfo[index]);
                    return Container(
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
                        onPressed: () {},
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
                    );
                  },
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
