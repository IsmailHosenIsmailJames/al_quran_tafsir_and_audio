import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/collect_info/pages/choice_tafsir_book.dart';
import 'package:al_quran_tafsir_and_audio/src/translations/map_of_translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../info_controller/info_controller_getx.dart';

class TafsirLanguage extends StatefulWidget {
  final bool? showAppBarNextButton;
  const TafsirLanguage({super.key, this.showAppBarNextButton});

  @override
  State<TafsirLanguage> createState() => _TafsirLanguageState();
}

class _TafsirLanguageState extends State<TafsirLanguage> {
  late List<String> language;
  void getLanguageList() {
    Set<String> temLanguages = {};
    for (int index = 0; index < allTafsir.length; index++) {
      String lanName = "${allTafsir[index]["language_name"]}";
      String tem = lanName[0];
      tem = tem.toUpperCase();
      lanName = tem + lanName.substring(1);
      temLanguages.add(lanName);
    }
    List<String> x = temLanguages.toList();
    x.sort();
    language = x;
  }

  @override
  void initState() {
    getLanguageList();
    super.initState();
  }

  final tafsirLanguage = Get.put(InfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select language for Quran's Tafsir".tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          if (widget.showAppBarNextButton == true)
            TextButton(
              onPressed: () {
                tafsirLanguage.tafsirBookIndex.value = -1;
                Navigator.pop(context);
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return const ChoiceTafsirBook(
                      showDownloadOnAppbar: true,
                    );
                  },
                );
              },
              child: const Text(
                'NEXT',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
        ],
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        padding:
            const EdgeInsets.only(bottom: 100, top: 10, left: 10, right: 10),
        itemCount: language.length,
        itemBuilder: (context, index) {
          String? nativeSpelling;
          for (var element in used20LanguageMap) {
            element['English'] == language[index]
                ? nativeSpelling = element['Native']
                : null;
          }
          nativeSpelling ??= language[index];
          return TextButton(
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
              backgroundColor: Colors.green.shade400.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            onPressed: () {
              int value = index;
              tafsirLanguage.tafsirIndex.value = value;
              tafsirLanguage.tafsirLanguage.value = language[value];
            },
            child: Obx(
              () => Row(
                children: [
                  Text(nativeSpelling ?? language[index],
                      style: const TextStyle(fontSize: 14)),
                  const Spacer(),
                  if (tafsirLanguage.tafsirIndex.value == index)
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
          );
        },
      ),
    );
  }
}
