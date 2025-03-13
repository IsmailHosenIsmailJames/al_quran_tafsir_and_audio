import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/core/show_twoested_message.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/collect_info/pages/choice_tafsir_book.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/collect_info/pages/intro.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/collect_info/pages/choice_language.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/download/download.dart';
import 'package:al_quran_tafsir_and_audio/src/theme/theme_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/theme/theme_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:toastification/toastification.dart';

import 'pages/choice_recitations.dart';
import '../info_controller/info_controller_getx.dart';
import 'pages/choice_translation_book.dart';
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
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    String nextButtonText = 'Next'.tr;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Al Quran'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [themeIconButton],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  pageIndex = value;
                });
              },
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const ChoiceLanguage(),
                const Intro(),
                const TranslationLanguage(),
                const ChoiceTranslationBook(),
                const TafsirLanguage(),
                const ChoiceTafsirBook(),
                const RecitationChoice(),
              ],
            ),
            Align(
              alignment: const Alignment(0, 1),
              child: GetX<AppThemeData>(
                builder: (controller) {
                  bool isDark = controller.themeModeName.value == 'dark' ||
                      (controller.themeModeName.value == 'system' &&
                          Theme.of(context).brightness == Brightness.dark);
                  return Container(
                    height: 40,
                    margin: const EdgeInsets.only(
                        top: 0, bottom: 5, left: 5, right: 5),
                    padding: const EdgeInsets.only(left: 2.5, right: 2.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: isDark
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
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10)),
                              onPressed: pageIndex != 0
                                  ? () {
                                      if (pageIndex > 0) {
                                        pageController.previousPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeIn);
                                      }
                                    }
                                  : null,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.arrow_back_outlined,
                                    size: 15,
                                  ),
                                  const Gap(5),
                                  Text(
                                    'Previous'.tr,
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
                          SmoothPageIndicator(
                            controller: pageController,
                            count: 7,
                            effect: const ExpandingDotsEffect(
                              dotHeight: 7,
                              dotWidth: 7,
                              spacing: 3,
                              expansionFactor: 4,
                              activeDotColor: Colors.green,
                              dotColor: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 35,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10)),
                              onPressed: () async {
                                if (pageIndex == 0) {
                                  if (infoController.appLanCode.value.isEmpty) {
                                    showTwoestedMessage(
                                      'Please Select Quran Translation Language'
                                          .tr,
                                      ToastificationType.info,
                                    );
                                    return;
                                  }
                                } else if (pageIndex == 2) {
                                  if (infoController
                                      .translationLanguage.value.isEmpty) {
                                    showTwoestedMessage(
                                      'Please select a language for app'.tr,
                                      ToastificationType.info,
                                    );

                                    return;
                                  }
                                } else if (pageIndex == 3) {
                                  if (infoController.bookNameIndex.value ==
                                      -1) {
                                    showTwoestedMessage(
                                      'Please Select Quran Translation Book'.tr,
                                      ToastificationType.info,
                                    );
                                    return;
                                  }
                                }
                                if (pageIndex == 4) {
                                  if (infoController.tafsirIndex.value == -1) {
                                    showTwoestedMessage(
                                      'Please Select Quran Tafsir Language'.tr,
                                      ToastificationType.info,
                                    );
                                    return;
                                  }
                                } else if (pageIndex == 5) {
                                  if (infoController.tafsirBookIndex.value ==
                                      -1) {
                                    showTwoestedMessage(
                                      'Please Select Quran Tafsir Book'.tr,
                                      ToastificationType.info,
                                    );
                                    return;
                                  }
                                } else if (pageIndex == 6) {
                                  if (infoController.tafsirBookIndex.value !=
                                          -1 &&
                                      infoController.tafsirIndex.value != -1 &&
                                      infoController.bookNameIndex.value !=
                                          -1 &&
                                      infoController.translationLanguage.value
                                          .isNotEmpty) {
                                    Map<String, String> info = {
                                      'translation_language': infoController
                                          .translationLanguage.value,
                                      'translation_book_ID': infoController
                                          .bookIDTranslation.value,
                                      'tafsir_language':
                                          infoController.tafsirLanguage.value,
                                      'tafsir_book_ID':
                                          infoController.tafsirBookID.value,
                                      'selected_reciter': infoController
                                          .selectedReciter.value
                                          .toJson(),
                                    };

                                    Get.offAll(() => DownloadData(
                                          selection: info,
                                        ));

                                    final box = await Hive.openBox('user_db');
                                    await box.put('selection_info', info);
                                    await box.put(
                                        'default_reciter',
                                        infoController.selectedReciter
                                            .toJson());
                                    log('message');
                                  } else {
                                    showTwoestedMessage(
                                      'Please select a default reciter'.tr,
                                      ToastificationType.info,
                                    );
                                  }
                                }
                                if (pageIndex < 6) {
                                  pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    pageIndex == 0
                                        ? 'Setup'.tr
                                        : nextButtonText,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPageIndicator(int index, int page) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: CircleAvatar(
        radius: index == page ? 5 : 3,
        backgroundColor: index == page ? Colors.green : Colors.grey,
      ),
    );
  }
}
