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
  const AddNewAyahForCollection({super.key});

  @override
  State<AddNewAyahForCollection> createState() =>
      _AddNewAyahForCollectionState();
}

class _AddNewAyahForCollectionState extends State<AddNewAyahForCollection> {
  int? selectedSurahNumber;
  int? selectedAyahNumber;
  InfoController infoController = Get.find();
  UniversalController universalController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Ayah"),
        actions: [
          if (selectedSurahNumber != null && selectedAyahNumber != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back(
                      result: "$selectedSurahNumber:$selectedAyahNumber",
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add")),
            )
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Select Surah",
                ),
                menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                items: List.generate(
                  114,
                  (index) {
                    String surahName = allChaptersInfo[index]["name_simple"];
                    return DropdownMenuItem(
                      value: index,
                      child: Text(
                        "${index + 1}. $surahName",
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
                  });
                },
              ),
            ),
            Gap(15),
            if (selectedSurahNumber != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select Ayah Number",
                  ),
                  menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                  items: List.generate(
                    ayahCount[selectedSurahNumber!],
                    (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(
                          "${index + 1}",
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
                  translationBookName: getTranslationBookName(infoController),
                  index: selectedAyahNumber!,
                  ayahStartFrom: ayahStartFormSurah(selectedSurahNumber!),
                  showAyahNumber: false,
                ),
              ),
            Gap(15),
            if (selectedSurahNumber != null && selectedAyahNumber != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Tafsir",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.all(7),
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
    if (translation["id"] ==
        int.parse(infoController.bookIDTranslation.value)) {
      return "${translation["name"]} by ${translation["author_name"]}";
    }
  }
  return "";
}

int ayahStartFormSurah(int surahNumber) {
  int toReturn = 0;
  for (int i = 0; i < surahNumber; i++) {
    toReturn += ayahCount[i];
  }
  return toReturn;
}
