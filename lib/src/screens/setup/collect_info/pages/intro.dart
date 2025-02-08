import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> points = [
      '📖 ${'Full Quran with 65+ Translations'.tr}',
      '📚 ${'12 Tafsir Books in 6 Languages'.tr}',
      '🎧 ${'40+ Recitations & Quran Audio Book'.tr}',
      '📝 ${'Rich Notes, Bookmarks & Collections'.tr}',
      '🔄 ${'Cloud Backup & Sync'.tr}',
      '📌 ${'History Tracking & Playlist Feature'.tr}',
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.6),
                  spreadRadius: 10,
                  blurRadius: 40,
                ),
              ],
              image: const DecorationImage(
                image: AssetImage(
                  'assets/img/QuranLogo.png',
                ),
              ),
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            child: Column(
              children: List.generate(
                points.length,
                (index) {
                  return Row(
                    children: [
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 18,
                      ),
                      const Gap(5),
                      Text(
                        points[index],
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
            )),
        MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(0.7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Data collected from'.tr),
              TextButton(
                onPressed: () {
                  launchUrl(Uri.parse('https://quran.com/'),
                      mode: LaunchMode.externalApplication);
                },
                child: const Text('quran.com'),
              ),
              Text('and'.tr),
              TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse('https://everyayah.com/'),
                        mode: LaunchMode.externalApplication);
                  },
                  child: const Text('everyayah.com')),
            ],
          ),
        ),
      ],
    );
  }
}
