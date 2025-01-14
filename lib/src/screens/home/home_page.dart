import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/audio_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/collection_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/profile_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/quran_tab.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/settings/settings_page.dart';
import 'package:al_quran_tafsir_and_audio/src/theme/theme_icon_button.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
        title: Text("Al Quran"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    insetPadding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                    ),
                  );
                },
              );
            },
            icon: Icon(
              FluentIcons.search_24_filled,
            ),
          ),
          IconButton(
            onPressed: () async {
              await Get.to(() => SettingsPage());
              setState(() {});
            },
            icon: Icon(FluentIcons.settings_24_filled),
          ),
        ],
      ),
      drawer: Drawer(
        child: themeIconButton,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              onPageChanged: (value) {
                setState(() {
                  selectedBottomNavIndex = value;
                });
              },
              controller: pageController,
              children: [
                QuranTab(),
                AudioTab(tabController: pageController),
                CollectionTab(
                  tabController: pageController,
                ),
                ProfileTab(),
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
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: GNav(
            selectedIndex: selectedBottomNavIndex,
            rippleColor: Colors.grey.withValues(alpha: 0.2),
            hoverColor: Colors.grey.withValues(alpha: 0.1),
            haptic: true,
            tabBorderRadius: 15,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 200),
            gap: 3,
            activeColor: Colors.white,
            iconSize: 24,
            tabBackgroundColor: Colors.green.shade700,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            tabs: [
              GButton(
                icon: FluentIcons.book_24_filled,
                text: 'Quran',
                borderRadius: BorderRadius.circular(30),
              ),
              GButton(
                icon: Icons.audiotrack_rounded,
                text: 'Recitation',
                borderRadius: BorderRadius.circular(30),
              ),
              GButton(
                icon: Icons.collections_bookmark_rounded,
                text: 'Collection',
                borderRadius: BorderRadius.circular(30),
              ),
              GButton(
                icon: FluentIcons.person_24_filled,
                text: 'Profile',
                borderRadius: BorderRadius.circular(30),
              )
            ],
            onTabChange: (value) {
              pageController.jumpToPage(value);
            },
          ),
        ),
      ),
    );
  }
}
