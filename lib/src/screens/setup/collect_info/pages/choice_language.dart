import 'package:al_quran_tafsir_and_audio/src/screens/setup/info_controller/info_controller_getx.dart';
import 'package:al_quran_tafsir_and_audio/src/translations/language_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/translations/map_of_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ChoiceLanguage extends StatefulWidget {
  const ChoiceLanguage({super.key});

  @override
  State<ChoiceLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<ChoiceLanguage> {
  final languageController = Get.put(LanguageController());
  final infoController = Get.put(InfoController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select a language for app'.tr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView.builder(
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 100, top: 10),
        itemCount: used20LanguageMap.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            height: 40,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 5, top: 5),
                backgroundColor: Colors.green.shade400.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              onPressed: () {
                String languageCode = used20LanguageMap[index]['Code']!;
                languageController.changeLanguage = languageCode;
                final box = Hive.box('user_db');
                box.put('app_lan', languageCode);
                infoController.appLanCode.value = languageCode;
              },
              child: Obx(
                () => Row(
                  children: [
                    Text(
                      used20LanguageMap[index]['Native'].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (used20LanguageMap[index]['Code'] ==
                        infoController.appLanCode.value)
                      const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
