import 'dart:io';

import 'package:al_quran_tafsir_and_audio/src/functions/safe_substring.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/collect_info/pages/choice_tafsir_language.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/collect_info/pages/choice_translation_language.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/info_controller/info_controller_getx.dart';
import 'package:al_quran_tafsir_and_audio/src/theme/theme_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/audio/controller/audio_controller.dart';
import '../../functions/get_cached_file_size_of_audio.dart';
import '../../resources/api_response/some_api_response.dart';
import '../../translations/language_controller.dart';
import '../../translations/map_of_translation.dart';
import '../surah_view/common/tajweed_scripts_composer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final audioController = Get.find<AudioController>();
  final appThemeDataController = Get.find<AppThemeData>();
  final universalController = Get.find<UniversalController>();
  final InfoController infoController = Get.find<InfoController>();
  final languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    String translationBookName = '';
    String translationWriter = '';
    String translationLanguage = '';
    for (Map translation in allTranslationLanguage) {
      if ("${translation['id']}" == infoController.bookIDTranslation.value) {
        translationBookName = '${translation['name']}';
        translationWriter = translation['author_name'];
        translationLanguage = translation['language_name'];
      }
    }

    String tafsirBookName = '';
    String tafsirWriter = '';
    String tafsirLanguage = '';
    for (Map tafsir in allTafsir) {
      if ("${tafsir['id']}" == infoController.tafsirBookID.value) {
        tafsirBookName = '${tafsir['name']}';
        tafsirWriter = tafsir['author_name'];
        tafsirLanguage = tafsir['language_name'];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(FluentIcons.settings_24_regular),
            const Gap(10),
            Text('Settings'.tr),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Brightness'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Gap(7),
            Obx(
              () => DropdownButtonFormField<String>(
                value: appThemeDataController.themeModeName.value,
                onChanged: (value) {
                  appThemeDataController.setTheme(value!);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: 'system',
                    child: Row(
                      children: [
                        const Gap(10),
                        const Icon(
                          Icons.brightness_4_rounded,
                          size: 18,
                        ),
                        const Gap(10),
                        Text('System default'.tr),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'dark',
                    child: Row(
                      children: [
                        const Gap(10),
                        const Icon(
                          Icons.dark_mode_rounded,
                          size: 18,
                        ),
                        const Gap(10),
                        Text('Dark'.tr),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'light',
                    child: Row(
                      children: [
                        const Gap(10),
                        const Icon(
                          Icons.light_mode_rounded,
                          size: 18,
                        ),
                        const Gap(10),
                        Text('Light'.tr),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(15),
            Text(
              'Quran Script Type'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Gap(10),
            Obx(
              () => DropdownButtonFormField<String>(
                value: universalController.quranScriptTypeGetx.value,
                onChanged: (value) {
                  universalController.quranScriptTypeGetx.value = value!;
                  Hive.box('user_db').put('quranScriptType', value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
                items: List.generate(
                  quranScriptTypeList.length,
                  (index) => DropdownMenuItem(
                    value: quranScriptTypeList[index],
                    child: Text(
                      quranScriptTypeList[index]
                          .capitalizeFirst
                          .replaceAll('_', ' '),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(15),
            Text(
              'Quran Font Size'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: universalController.fontSizeArabic.value,
                      min: 10,
                      max: 50,
                      divisions: 40,
                      onChanged: (value) {
                        universalController.fontSizeArabic.value = value;
                        Hive.box('user_db').put('fontSizeArabic', value);
                      },
                    ),
                  ),
                  const Gap(5),
                  Text(
                    universalController.fontSizeArabic.value.round().toString(),
                  ),
                  const Gap(10),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(
                  alpha: 0.2,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
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
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            const Gap(15),
            Text(
              'Translation Font Size'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: universalController.fontSizeTranslation.value,
                      min: 10,
                      max: 50,
                      divisions: 40,
                      onChanged: (value) {
                        universalController.fontSizeTranslation.value = value;
                        Hive.box('user_db').put('fontSizeTranslation', value);
                      },
                    ),
                  ),
                  const Gap(5),
                  Text(
                    universalController.fontSizeArabic.value.round().toString(),
                  ),
                  const Gap(10),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(
                  alpha: 0.2,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Obx(
                () => Text(
                  Hive.box('translation_db').get(
                    '${infoController.bookIDTranslation.value}/0',
                    defaultValue: '',
                  ),
                  style: TextStyle(
                    fontSize: universalController.fontSizeTranslation.value,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            const Gap(15),
            Text(
              'Translation Book'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.grey.withValues(alpha: 0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book Name'.tr,
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text(
                        safeSubString(translationBookName, 27),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Gap(5),
                      Text(
                        'Author'.tr,
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text(
                        safeSubString(translationWriter, 27),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Gap(5),
                      Text(
                        'Language'.tr,
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text(
                        translationLanguage.capitalizeFirst,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      await Get.to(
                        () => const TranslationLanguage(
                          showNextButtonOnAppBar: true,
                        ),
                      );
                      setState(() {});
                    },
                    child: Text(
                      'Change'.tr,
                    ),
                  )
                ],
              ),
            ),
            const Gap(15),
            Text(
              'Tafsir Book'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.grey.withValues(alpha: 0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book Name'.tr,
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text(
                        safeSubString(tafsirBookName, 27),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Gap(5),
                      Text(
                        'Author'.tr,
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text(
                        safeSubString(tafsirWriter, 27),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Gap(5),
                      Text(
                        'Language'.tr,
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text(
                        tafsirLanguage.capitalizeFirst,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      await Get.to(
                        () => const TafsirLanguage(
                          showAppBarNextButton: true,
                        ),
                      );
                      setState(() {});
                    },
                    child: Text(
                      'Change'.tr,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Text(
                    'App Language'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(15),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: DropdownButtonFormField(
                        padding: EdgeInsets.zero,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 10),
                        ),
                        value: Get.locale?.languageCode ?? 'en',
                        items: List.generate(
                          used20LanguageMap.length,
                          (index) {
                            return DropdownMenuItem(
                              value: used20LanguageMap[index]['Code']!,
                              onTap: () {
                                String languageCode =
                                    used20LanguageMap[index]['Code']!;
                                languageController.changeLanguage =
                                    languageCode;
                                final box = Hive.box('user_db');
                                box.put('app_lan', languageCode);
                                infoController.appLanCode.value = languageCode;
                              },
                              child: Text(used20LanguageMap[index]['Native']!),
                            );
                          },
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(15),
            Text(
              'Audio Cached'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Gap(5),
            Container(
              margin: const EdgeInsets.only(
                left: 5,
                top: 5,
                bottom: 5,
                right: 5,
              ),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(7),
              ),
              child: FutureBuilder(
                future: getCategorizedCacheFilesWithSize(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, List<Map<String, dynamic>>> data =
                        snapshot.data!;

                    List<String> keys = data.keys.toList();

                    return getListOfCacheWidget(keys, data);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Cache Not Found'.tr,
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column getListOfCacheWidget(
      List<String> keys, Map<String, List<Map<String, dynamic>>> data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 100, child: Text('Cache Size'.tr)),
            SizedBox(
              width: 100,
              child: FutureBuilder<int>(
                future: justAudioCache(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(formatBytes(snapshot.data ?? 0));
                  }
                },
              ),
            ),
            SizedBox(
              width: 100,
              height: 25,
              child: ElevatedButton(
                onPressed: () async {
                  for (var key in data.keys) {
                    var value = data[key];

                    // ignore: avoid_function_literals_in_foreach_calls
                    for (var element in value!) {
                      await File(element['path']).delete();
                    }
                  }
                  setState(() {});
                },
                child: Text('Clean'.tr),
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 100, child: Text('Last Modified'.tr)),
            SizedBox(width: 100, child: Text('Cache Size'.tr)),
            const Gap(100),
          ],
        ),
        const Gap(10),
        ...List.generate(
          keys.length,
          (index) {
            List<Map<String, dynamic>> current = data[keys[index]]!;

            int fileSize = 0;

            for (var fileInfo in current) {
              fileSize += (fileInfo['size'] ?? 0) as int;
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 100, child: Text(keys[index])),
                SizedBox(
                    width: 100,
                    child: Text((formatBytes(fileSize, 2)).toString())),
                SizedBox(
                  width: 100,
                  height: 29,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                    child: OutlinedButton(
                      onPressed: () async {
                        for (var element in current) {
                          await File(element['path']).delete();
                        }
                        setState(() {});
                      },
                      child: Text('Clean'.tr),
                    ),
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}

Future<Map<String, List<Map<String, dynamic>>>>
    getCategorizedCacheFilesWithSize() async {
  Map<String, List<Map<String, dynamic>>> categorizedFiles = {};
  final cacheDir = Directory(
      join((await getTemporaryDirectory()).path, 'just_audio_cache', 'remote'));
  final files = cacheDir
      .listSync()
      .whereType<File>(); // List all files in the cache directory

  final now = DateTime.now();

  for (var file in files) {
    final lastModified = file.lastModifiedSync().second;

    final differenceInDays =
        Duration(seconds: now.second - lastModified).inDays;
    final fileSize = file.lengthSync(); // Get the file size

    final fileInfo = {
      'path': file.path,
      'size': fileSize,
    };

    String timeKey = getTheTimeKey(differenceInDays);
    List<Map<String, dynamic>> tem = categorizedFiles[timeKey] ?? [];
    tem.add(fileInfo);
    categorizedFiles[timeKey] = tem;
  }

  return categorizedFiles;
}

String getTheTimeKey(int distanceInDay) {
  String timeKey = '';
  if (distanceInDay > 365) {
    timeKey = '1 Year ago';
  } else if (distanceInDay > 182) {
    timeKey = '6 Months ago';
  } else if (distanceInDay > 91) {
    timeKey = '3 Months ago';
  } else if (distanceInDay > 60) {
    timeKey = '2 Months ago';
  } else if (distanceInDay > 30) {
    timeKey = '1 Month ago';
  } else if (distanceInDay > 21) {
    timeKey = '3 Weeks ag0';
  } else if (distanceInDay > 14) {
    timeKey = '2 Weeks ago';
  } else if (distanceInDay > 7) {
    timeKey = '1 Weeks ago';
  } else if (distanceInDay > 6) {
    timeKey = '6 Days ago';
  } else if (distanceInDay > 5) {
    timeKey = '5 Days ago';
  } else if (distanceInDay > 4) {
    timeKey = '4 Days ago';
  } else if (distanceInDay > 3) {
    timeKey = '3 Days ago';
  } else if (distanceInDay > 2) {
    timeKey = '2 Days ago';
  } else if (distanceInDay > 1) {
    timeKey = '1 Day ago';
  } else {
    timeKey = 'Today';
  }
  return timeKey;
}
