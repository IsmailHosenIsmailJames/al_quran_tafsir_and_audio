import 'package:al_quran_tafsir_and_audio/src/functions/common_functions.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/collect_info/pages/choice_tafsir_book.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/collect_info/pages/intro.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/collect_info/pages/choice_language.dart';
import 'package:al_quran_tafsir_and_audio/src/theme/theme_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/theme/theme_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';

import '../init_page.dart';
import 'pages/choice_recitations.dart';
import '../getx/get_controller.dart';
import 'pages/choice_tranlation_book.dart';
import 'pages/choice_tafsir_language.dart';
import 'pages/choice_translation_language.dart';

class CollectInfoPage extends StatefulWidget {
  final int pageNumber;
  const CollectInfoPage({super.key, required this.pageNumber});

  @override
  State<CollectInfoPage> createState() => _CollectInfoPageState();
}

class _CollectInfoPageState extends State<CollectInfoPage> {
  late int indexPage;

  @override
  void initState() {
    indexPage = widget.pageNumber;
    pageIndex = widget.pageNumber;
    super.initState();
  }

  final infoController = Get.put(InfoController());
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    String nextButtonText = "Next".tr;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Al Quran".tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                launchUrl(
                  Uri.parse(
                      "https://www.freeprivacypolicy.com/live/d8c08904-a100-4f0b-94d8-13d86a8c8605"),
                );
              },
              child: Text("Privacy Policy".tr),
            ),
          ],
        ),
        actions: [themeIconButton],
      ),
      body: Stack(
        children: [
          [
            const ChoiceLanguage(),
            const Intro(),
            const TranslationLanguage(),
            const ChoiceTranslationBook(),
            const TafsirLanguage(),
            const ChoiceTafsirBook(),
            const RecitationChoice(),
          ][pageIndex],
          Align(
            alignment: const Alignment(0, 1),
            child: GetX<AppThemeData>(
              builder: (controller) => Container(
                height: 40,
                margin:
                    const EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),
                padding: const EdgeInsets.only(left: 2.5, right: 2.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: controller.isDark.value ||
                          (controller.isDark.value == false &&
                              Theme.of(context).brightness == Brightness.dark)
                      ? const Color.fromARGB(255, 29, 29, 29)
                      : const Color.fromARGB(255, 220, 220, 220),
                ),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 35,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10)),
                          onPressed: pageIndex != 0
                              ? () {
                                  if (pageIndex > 0) {
                                    setState(() {
                                      pageIndex--;
                                    });
                                  }
                                }
                              : null,
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back_outlined,
                                size: 15,
                              ),
                              const Gap(5),
                              Text(
                                "previous".tr,
                                style: textTheme.bodyMedium!.copyWith(
                                  color: pageIndex != 0
                                      ? Colors.green
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          getPageIndicator(0, pageIndex),
                          getPageIndicator(1, pageIndex),
                          getPageIndicator(2, pageIndex),
                          getPageIndicator(3, pageIndex),
                          getPageIndicator(4, pageIndex),
                          getPageIndicator(5, pageIndex),
                          getPageIndicator(6, pageIndex),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 35,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10)),
                          onPressed: () async {
                            if (pageIndex == 0) {
                              if (infoController.appLanCode.value.isEmpty) {
                                showToastedMessage(
                                    "Please Select Quran Translation Language");
                                return;
                              }
                            } else if (pageIndex == 2) {
                              if (infoController
                                  .translationLanguage.value.isEmpty) {
                                showToastedMessage(
                                    "Please select a language for app");

                                return;
                              }
                            } else if (pageIndex == 3) {
                              if (infoController.bookNameIndex.value == -1) {
                                showToastedMessage(
                                    "Please Select Quran Translation Book");
                                return;
                              }
                            }
                            if (pageIndex == 4) {
                              if (infoController.tafsirIndex.value == -1) {
                                showToastedMessage(
                                    "Please Select Quran Tafsir Language");
                                return;
                              }
                            } else if (pageIndex == 5) {
                              if (infoController.tafsirBookIndex.value == -1) {
                                showToastedMessage(
                                    "Please Select Quran Tafsir Book");
                                return;
                              }
                            } else if (pageIndex == 6) {
                              if (infoController.recitationIndex.value != -1 &&
                                  infoController.tafsirBookIndex.value != -1 &&
                                  infoController.tafsirIndex.value != -1 &&
                                  infoController.bookNameIndex.value != -1 &&
                                  infoController
                                      .translationLanguage.value.isNotEmpty) {
                                Map<String, String> info = {
                                  "translation_language":
                                      infoController.translationLanguage.value,
                                  "translation_book_ID":
                                      infoController.bookIDTranslation.value,
                                  "tafsir_language":
                                      infoController.tafsirLanguage.value,
                                  "tafsir_book_ID":
                                      infoController.tafsirBookID.value,
                                  "recitation_ID":
                                      infoController.recitationName.value,
                                };
                                if (Hive.isBoxOpen("info")) {
                                  final box = Hive.box("user_db");

                                  box.put("info", info);
                                  Get.offAll(() => const InitPage());
                                } else {
                                  final box = Hive.box("user_db");

                                  box.put("info", info);
                                  Get.offAll(() => const InitPage());
                                }
                              }
                            }
                            if (pageIndex < 6) {
                              setState(() {
                                pageIndex++;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                pageIndex == 0 ? "Setup".tr : nextButtonText,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const Gap(5),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getPageIndicator(int index, int page) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: CircleAvatar(
        radius: index == page ? 7 : 4,
        backgroundColor: index == page ? Colors.green : Colors.grey,
      ),
    );
  }
}
