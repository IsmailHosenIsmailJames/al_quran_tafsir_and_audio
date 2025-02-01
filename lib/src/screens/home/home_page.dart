import 'package:al_quran_tafsir_and_audio/src/screens/home/drawer/my_app_drawer.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/audio_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/collection_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/profile_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/quran_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/settings/settings_page.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/audio/controller/audio_controller.dart';
import '../../core/audio/play_quran_audio.dart';
import '../../core/audio/widget_audio_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  int selectedBottomNavIndex = 0;
  AudioController audioController = ManageQuranAudio.audioController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al Quran'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return getSearchWidgetPopup();
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedBottomNavIndex,
        onTap: (value) {
          pageController.jumpToPage(value);
        },
        selectedItemColor: Colors.green.shade600,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.book_24_filled),
            label: 'Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.audiotrack_rounded),
            label: 'Recitation',
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.collections_24_filled),
            label: 'Collection',
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.person_24_filled),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Dialog getSearchWidgetPopup() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      insetPadding: const EdgeInsets.all(10),
      child: const SizedBox(
        width: double.infinity,
        height: 200,
      ),
    );
  }
}
