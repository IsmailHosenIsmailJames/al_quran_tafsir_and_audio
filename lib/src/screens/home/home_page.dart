import 'package:al_quran_tafsir_and_audio/src/screens/home/drawer/my_app_drawer.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/search/show_search_result.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/audio_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/collection_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/profile_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/quran_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/settings/settings_page.dart';
import 'package:al_quran_tafsir_and_audio/src/translations/map_of_translation.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../core/audio/controller/audio_controller.dart';
import '../../core/audio/play_quran_audio.dart';
import '../../core/audio/widget_audio_controller.dart';
import '../../theme/theme_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  int selectedBottomNavIndex = 0;
  AudioController audioController = ManageQuranAudio.audioController;
  AppThemeData themeController = Get.put(AppThemeData());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Al Quran'.tr),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return getSearchWidgetPopup(context);
                },
              );
            },
            icon: const Icon(
              FluentIcons.search_24_filled,
            ),
          ),
          IconButton(
            onPressed: () async {
              await Get.to(() => const SettingsPage());
              setState(() {});
            },
            icon: const Icon(FluentIcons.settings_24_filled),
          ),
        ],
      ),
      drawer: MyAppDrawer(pageController: pageController),
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                selectedBottomNavIndex = value;
              });
            },
            controller: pageController,
            children: [
              const QuranTab(),
              AudioTab(tabController: pageController),
              CollectionTab(
                tabController: pageController,
              ),
              const ProfileTab(),
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
      ),
      bottomNavigationBar: Obx(
        () {
          bool isDark = (themeController.themeModeName.value == 'dark' ||
              (themeController.themeModeName.value == 'system' &&
                  MediaQuery.of(context).platformBrightness ==
                      Brightness.dark));
          return BottomNavigationBar(
            currentIndex: selectedBottomNavIndex,
            onTap: (value) {
              pageController.jumpToPage(value);
            },
            selectedItemColor: Colors.green.shade600,
            unselectedItemColor: isDark ? Colors.white : Colors.grey.shade700,
            backgroundColor: Colors.green.shade700,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(FluentIcons.book_24_filled),
                label: 'Quran'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.audiotrack_rounded),
                label: 'Recitation'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(FluentIcons.collections_24_filled),
                label: 'Collection'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(FluentIcons.person_24_filled),
                label: 'Profile'.tr,
              ),
            ],
          );
        },
      ),
    );
  }
}

Dialog getSearchWidgetPopup(BuildContext context) {
  TextEditingController controller = TextEditingController();
  String lanCode = Get.locale?.languageCode ?? 'en';
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
    ),
    insetPadding: const EdgeInsets.all(10),
    child: SizedBox(
      width: double.infinity,
      // height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 20,
            ),
            child: SearchBar(
              autoFocus: true,
              controller: controller,
              shape: const WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  ),
                  side: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(
                Colors.grey.withValues(alpha: 0.1),
              ),
              elevation: const WidgetStatePropertyAll(0),
              leading: const Icon(
                Icons.search_rounded,
              ),
              hintText: '${'type to search'.tr}...',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('${'Search'.tr} ${'Language'.tr}'),
                const Gap(10),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: DropdownButtonFormField(
                      padding: EdgeInsets.zero,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                      value: lanCode,
                      items: List.generate(
                        used20LanguageMap.length,
                        (index) {
                          return DropdownMenuItem(
                            value: used20LanguageMap[index]['Code']!,
                            onTap: () {
                              lanCode = used20LanguageMap[index]['Code']!;
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Get.to(
                    () => ShowSearchResult(
                      searchQuery: controller.text,
                      lanCode: lanCode,
                    ),
                  );
                },
                label: Text('Search'.tr),
                icon: const Icon(Icons.search_rounded),
              ),
            ),
          ),
          const Gap(10),
        ],
      ),
    ),
  );
}
