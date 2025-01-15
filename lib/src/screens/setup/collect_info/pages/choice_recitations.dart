// import 'package:audioplayers/audioplayers.dart';
import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/core/audio/controller/audio_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/core/audio/resources/quran_com/all_recitations.dart';
import 'package:al_quran_tafsir_and_audio/src/core/audio/resources/recitation_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/core/audio/resources/every_ayah_com/recitations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/audio/play_quran_audio.dart';
import '../../../../core/audio/widget_audio_controller.dart';
import '../../info_controller/info_controller_getx.dart';

class RecitationChoice extends StatefulWidget {
  final ReciterInfoModel? previousInfo;
  const RecitationChoice({super.key, this.previousInfo});

  @override
  State<RecitationChoice> createState() => _RecitationChoiceState();
}

class _RecitationChoiceState extends State<RecitationChoice> {
  final infoController = Get.put(InfoController());
  final AudioController audioController = Get.find<AudioController>();
  late List<ReciterInfoModel> allRecitationSearch = [];

  @override
  void initState() {
    loadRecitationsData();
    super.initState();
  }

  loadRecitationsData() {
    allRecitationSearch = [];
    if (selectedTabForAudioSource == 0) {
      for (var element in recitationsInfoListEveryAyahCom) {
        log(element.toString());
        allRecitationSearch.add(ReciterInfoModel.fromMap(element));
      }
    }
    if (selectedTabForAudioSource == 1) {
      for (var element in recitationsListOfQuranCom) {
        log(element.toString());
        allRecitationSearch.add(ReciterInfoModel.fromMap(element));
      }
    }
    setState(() {});
  }

  void select(int index) {
    infoController.selectedReciter.value = allRecitationSearch[index];
    audioController.currentReciterModel.value = allRecitationSearch[index];
  }

  void searchOnList(String text) {
    List<ReciterInfoModel> matched = [];
    for (var element in recitationsInfoListEveryAyahCom) {
      final tem = ReciterInfoModel.fromMap(element);
      if (tem.name.toLowerCase().contains(text) == true ||
          tem.link.toLowerCase().contains(text) == true) {
        matched.add(ReciterInfoModel.fromMap(element));
      }
    }
    log(text);
    log(matched.length.toString());
    setState(() {
      allRecitationSearch = matched;
    });
  }

  int selectedTabForAudioSource = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choice Recitation",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Map<String, String> info = {
                "translation_language":
                    infoController.translationLanguage.value,
                "translation_book_ID": infoController.bookIDTranslation.value,
                "tafsir_language": infoController.tafsirLanguage.value,
                "tafsir_book_ID": infoController.tafsirBookID.value,
                "selected_reciter":
                    audioController.currentReciterModel.value.toJson(),
              };
              Hive.box("user_db").put("selection_info", info);
              toastification.show(
                context: context,
                title: Text("Saved"),
                type: ToastificationType.success,
              );
              Get.back(result: audioController.currentReciterModel.value);
            },
            icon: Icon(Icons.done),
            label: Text("Change"),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5, bottom: 2, top: 2),
                child: CupertinoSearchTextField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  autofocus: false,
                  onChanged: (value) {
                    searchOnList(value.toLowerCase());
                  },
                ),
              ),
              Container(
                height: 40,
                width: double.infinity,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: selectedTabForAudioSource != 0
                          ? TextButton(
                              onPressed: () {
                                selectedTabForAudioSource = 0;
                                loadRecitationsData();
                              },
                              child: Text(
                                "everyayah.com",
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                selectedTabForAudioSource = 0;
                                loadRecitationsData();
                              },
                              child: Text(
                                "everyayah.com",
                              ),
                            ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: selectedTabForAudioSource != 1
                          ? TextButton(
                              onPressed: () {
                                selectedTabForAudioSource = 1;
                                loadRecitationsData();
                              },
                              child: Text(
                                "quran.com",
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                selectedTabForAudioSource = 1;
                                loadRecitationsData();
                              },
                              child: Text(
                                "quran.com",
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      bottom: 100, top: 10, left: 1, right: 1),
                  itemCount: allRecitationSearch.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 5, top: 5),
                          backgroundColor:
                              Colors.green.shade400.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        onPressed: () {
                          select(index);
                        },
                        child: getWidgetForReciters(index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(
              () => audioController.isReadyToControl.value
                  ? WidgetAudioController(
                      showSurahNumber: false,
                      showQuranAyahMode: true,
                      surahNumber: audioController.currentPlayingAyah.value,
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Container getWidgetForReciters(int index) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      child: Obx(
        () => Stack(
          children: [
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getAudioPlayIconButton(index),
                  const Gap(10),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        allRecitationSearch[index].name,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (infoController.selectedReciter.value.link ==
                allRecitationSearch[index].link)
              const Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  SizedBox getAudioPlayIconButton(int index) {
    return SizedBox(
      height: 30,
      width: 30,
      child: GetX<AudioController>(
        builder: (controller) => IconButton(
          iconSize: 18,
          onPressed: () async {
            if (audioController.isPlaying.value &&
                audioController.currentReciterIndex.value == index) {
              ManageQuranAudio.audioPlayer.pause();
            } else if (audioController.currentReciterIndex.value == index) {
              controller.currentReciterIndex.value = index;
              controller.currentReciterModel.value = allRecitationSearch[index];
              controller.totalAyah.value = 7;
              ManageQuranAudio.audioPlayer.play();
            } else {
              controller.currentReciterIndex.value = index;
              controller.currentReciterModel.value = allRecitationSearch[index];
              controller.totalAyah.value = 7;
              await Hive.box('user_db')
                  .put('reciter', allRecitationSearch[index].toJson());
              ManageQuranAudio.playMultipleAyahAsPlayList(
                surahNumber: 0,
                reciter: allRecitationSearch[index],
              );
            }
          },
          icon: controller.isLoading.value &&
                  controller.currentReciterIndex.value == index
              ? const CircularProgressIndicator(
                  strokeWidth: 2,
                )
              : Icon(
                  (controller.isPlaying.value &&
                          controller.currentReciterIndex.value == index)
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
