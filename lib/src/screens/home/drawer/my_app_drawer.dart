import 'package:al_quran_tafsir_and_audio/src/screens/about_app/about_app_page.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/developer/developer_page.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/home_page.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/create_new_collection.dart/add_new_ayah.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/my_developed_apps/my_developed_apps.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/platforms/others_platform.dart';
import 'package:al_quran_tafsir_and_audio/src/theme/theme_icon_button.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAppDrawer extends StatelessWidget {
  const MyAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(bottom: 50),
        children: [
          Container(
            height: 165,
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: AssetImage("assets/img/QuranLogo.png"),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.2),
                          spreadRadius: 10,
                          blurRadius: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FutureBuilder(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        return Text(
                          "v${snapshot.data?.version}",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: themeIconButton,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: CloseButton(
                    color: Colors.green.shade600,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.withValues(
                        alpha: 0.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(20),
          ListTile(
            minTileHeight: 45,
            onTap: () {
              Navigator.pop(context);
              Get.off(() => HomePage());
            },
            leading: Icon(
              FluentIcons.home_24_filled,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "Home",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            minTileHeight: 45,
            onTap: () {
              Get.to(
                () => AddNewAyahForCollection(
                  isJumpToAyah: true,
                ),
              );
            },
            leading: Icon(
              Icons.subdirectory_arrow_right_rounded,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "Jump to Ayah",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            minTileHeight: 45,
            onTap: () {},
            leading: Icon(
              FluentIcons.notepad_24_filled,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "Notes",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            minTileHeight: 45,
            onTap: () {},
            leading: Icon(
              FluentIcons.bookmark_24_filled,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "Bookmarks",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            minTileHeight: 45,
            onTap: () {},
            leading: Icon(
              Icons.favorite_outlined,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "Favorites",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            minTileHeight: 45,
            onTap: () {
              Navigator.pop(context);
              Get.to(() => OthersPlatform());
            },
            leading: Icon(
              Icons.laptop_windows_rounded,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "Others Platforms",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            minTileHeight: 45,
            onTap: () {
              Get.to(
                () => AboutAppPage(),
              );
            },
            leading: Icon(
              Icons.info_rounded,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "About App",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            minTileHeight: 45,
            onTap: () {
              Navigator.pop(context);
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'md.ismailhosenismailjames@gmail.com',
                query: encodeQueryParameters(<String, String>{
                  'subject': 'Feedback of Al Quran Tafsir and Audio App',
                }),
              );

              launchUrl(emailLaunchUri);
            },
            leading: Icon(
              FluentIcons.person_feedback_48_filled,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "Give Feedback",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            minTileHeight: 45,
            onTap: () async {
              final InAppReview inAppReview = InAppReview.instance;

              if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
              }
            },
            leading: Icon(
              Icons.star_rounded,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "Rate App",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            minTileHeight: 45,
            onTap: () {
              Navigator.pop(context);
              launchUrl(
                Uri.parse(
                    "https://www.freeprivacypolicy.com/live/d8c08904-a100-4f0b-94d8-13d86a8c8605"),
              );
            },
            leading: Icon(
              Icons.privacy_tip_rounded,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            minTileHeight: 45,
            onTap: () {
              Navigator.pop(context);
              Share.share(
                'Here is Quran App with Quran Tafsir and Audio\nhttps://play.google.com/store/apps/details?id=com.ismail_hosen_james.al_bayan_quran',
              );
            },
            leading: Icon(
              Icons.share_rounded,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "Share App",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            minTileHeight: 45,
            onTap: () {
              Navigator.pop(context);
              // Show My Developed all apps
              Get.to(() => MyDevelopedApps());
            },
            leading: Icon(
              Icons.more_horiz,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "My Apps",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            minTileHeight: 45,
            onTap: () {
              Get.to(() => DeveloperPage());
            },
            leading: Icon(
              Icons.handyman_outlined,
              color: Colors.green.shade600,
              size: 20,
            ),
            title: Text(
              "About Developer",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
