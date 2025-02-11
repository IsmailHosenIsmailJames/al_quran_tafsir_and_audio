import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/info_controller/info_controller_getx.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/surah_view/tafsir_view/tafsir_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../surah_view/surah_view.dart';

class AddNewAyahForCollection extends StatefulWidget {
  final int? selectedSurahNumber;
  final int? selectedAyahNumber;
  final String? surahName;
  final bool? isJumpToAyah;
  const AddNewAyahForCollection({
    super.key,
    this.selectedSurahNumber,
    this.selectedAyahNumber,
    this.surahName,
    this.isJumpToAyah,
  });

  @override
  State<AddNewAyahForCollection> createState() =>
      _AddNewAyahForCollectionState();
}

class _AddNewAyahForCollectionState extends State<AddNewAyahForCollection> {
  late int? selectedSurahNumber = widget.selectedSurahNumber;
  late int? selectedAyahNumber = widget.selectedAyahNumber;
  late String? surahName = widget.surahName;
  InfoController infoController = Get.find();
  UniversalController universalController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: surahName == null
            ? Text('Select Ayah'.tr)
            : Text(
                '$surahName ${(selectedSurahNumber ?? 0) + 1}:${(selectedAyahNumber ?? 0) + 1} '),
        actions: [
          if (selectedSurahNumber != null &&
              selectedAyahNumber != null &&
              widget.isJumpToAyah != true)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back(
                      result: '$selectedSurahNumber:$selectedAyahNumber',
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add')),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButtonFormField(
                value: selectedSurahNumber,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Select Surah'.tr,
                ),
                menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                items: List.generate(
                  114,
                  (index) {
                    String surahName = allChaptersInfo[index]['name_simple'];
                    return DropdownMenuItem(
                      value: index,
                      child: Text(
                        '${index + 1}. $surahName',
                      ),
                    );
                  },
                ),
                onChanged: (value) {
                  setState(() {
                    selectedAyahNumber = null;
                  });

                  setState(() {
                    selectedSurahNumber = value;
                    surahName = allChaptersInfo[value!]['name_simple'];
                  });
                },
              ),
            ),
            if (selectedSurahNumber != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButtonFormField(
                  value: selectedAyahNumber,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Select Ayah'.tr,
                  ),
                  menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                  items: List.generate(
                    ayahCount[selectedSurahNumber!],
                    (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(
                          '${index + 1}',
                        ),
                      );
                    },
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedAyahNumber = value;
                    });
                  },
                ),
              ),
            if (selectedSurahNumber != null && selectedAyahNumber != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildAyahWidget(
                  currentAyahIndex: ayahStartFormSurah(selectedSurahNumber!) +
                      selectedAyahNumber!,
                  infoController: infoController,
                  universalController: universalController,
                  index: selectedAyahNumber!,
                  ayahStartFrom: ayahStartFormSurah(selectedSurahNumber!),
                  showAyahNumber: false,
                ),
              ),
            const Gap(15),
            if (selectedSurahNumber != null && selectedAyahNumber != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Tafsir'.tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            if (selectedSurahNumber != null && selectedAyahNumber != null)
              Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.grey.withValues(
                    alpha: 0.2,
                  ),
                ),
                padding: const EdgeInsets.all(7),
                margin: const EdgeInsets.all(7),
                child: TafsirView(
                  ayahNumber: ayahStartFormSurah(selectedSurahNumber!) +
                      selectedAyahNumber!,
                  tafsirBookID: infoController.tafsirBookID.value,
                  showAppBar: false,
                ),
              )
          ],
        ),
      ),
    );
  }
}

String getTranslationBookName(InfoController infoController) {
  log(infoController.bookIDTranslation.value);
  for (Map translation in allTranslationLanguage) {
    if (translation['id'] ==
        int.parse(infoController.bookIDTranslation.value)) {
      return "${translation["name"]} by ${translation["author_name"]}";
    }
  }
  return '';
}

int ayahStartFormSurah(int surahNumber) {
  int toReturn = 0;
  for (int i = 0; i < surahNumber; i++) {
    toReturn += ayahCount[i];
  }
  return toReturn;
}
