import 'package:al_quran_tafsir_and_audio/src/core/audio/controller/audio_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/core/audio/play_quran_audio.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/collect_info/pages/choice_recitations.dart';
import 'package:al_quran_tafsir_and_audio/src/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../core/audio/resources/recitation_info_model.dart';
import '../../surah_view/common/tajweed_scripts_composer.dart';
import '../controller/home_page_controller.dart';
import '../controller/model/play_list_model.dart';

class AudioTab extends StatefulWidget {
  final PageController tabController;
  const AudioTab({super.key, required this.tabController});

  @override
  State<AudioTab> createState() => _AudioTabState();
}

class _AudioTabState extends State<AudioTab> {
  final AudioController audioController = ManageQuranAudio.audioController;
  final HomePageController homePageController = Get.put(HomePageController());
  final UniversalController universalController = Get.find();
  final AppThemeData themeController = Get.find<AppThemeData>();
  final ScrollController scrollController = ScrollController();
  final userDB = Hive.box("user_db");
  final quranDB = Hive.box("quran_db");

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.grey.shade600.withValues(alpha: 0.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Reciter",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    height: 25,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        backgroundColor: Colors.green.shade800,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        int temSurahNumber =
                            audioController.currentSurahNumber.value;
                        int temAyahNumber =
                            audioController.currentPlayingAyah.value;
                        ManageQuranAudio.audioPlayer.stop();
                        final result = await Get.to(
                          () => RecitationChoice(
                            previousInfo:
                                audioController.currentReciterModel.value,
                          ),
                        );

                        if (result.runtimeType == ReciterInfoModel) {
                          audioController.currentReciterModel.value =
                              result as ReciterInfoModel;
                        }
                        if (audioController.currentPlayingAyah.value != -1) {
                          if (audioController.isPlaying.value) {
                            await ManageQuranAudio.playMultipleAyahAsPlayList(
                              surahNumber: temSurahNumber,
                              reciter:
                                  audioController.currentReciterModel.value,
                              startOn: temAyahNumber,
                            );
                          } else {
                            await ManageQuranAudio.playMultipleAyahAsPlayList(
                              surahNumber: temSurahNumber,
                              playInstantly: false,
                              reciter:
                                  audioController.currentReciterModel.value,
                              startOn: temAyahNumber,
                            );
                          }
                        }
                      },
                      child: const Text("Change"),
                    ),
                  ),
                ],
              ),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    audioController.currentReciterModel.value.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => (homePageController.selectForPlaylistMode.value == false)
              ? const SizedBox()
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade400.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              const Text("Adding to"),
                              const Gap(5),
                              Text(
                                homePageController.nameOfEditingPlaylist.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Gap(5),
                          SizedBox(
                            height: 25,
                            child: Row(
                              children: [
                                Text(
                                    "Selected: ${homePageController.selectedForPlaylist.length}"),
                                const Spacer(),
                                const Gap(5),
                                OutlinedButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.only(
                                        left: 7, right: 7),
                                  ),
                                  onPressed: () {
                                    homePageController
                                        .selectForPlaylistMode.value = false;
                                    homePageController.selectedForPlaylist
                                        .clear();
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text("Cancel"),
                                ),
                                const Gap(5),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    addSelectedDataToPlayList(context);
                                  },
                                  icon: const Icon(Icons.done),
                                  label: const Text("Done"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            interactive: true,
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 100),
              itemCount: allChaptersInfo.length,
              itemBuilder: (context, index) {
                PlayListModel currentPlaylist = PlayListModel(
                  reciter: audioController.currentReciterModel.value,
                  surahNumber: index,
                );
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    int ayahStart = 0;
                    for (int i = 0; i < index; i++) {
                      ayahStart += ayahCount[i];
                    }
                    showPopUpForQuranWithTajweedText(context, index, ayahStart);
                  },
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    child: Obx(
                      () => Row(
                        children: [
                          const Gap(3),
                          SizedBox(
                            height: 34,
                            width: 34,
                            child: getPlayButton(index, audioController),
                          ),
                          const Gap(10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ("${index + 1}. ${allChaptersInfo[index]['name_simple'] ?? ""}")
                                    .replaceAll("-", " "),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                "${(allChaptersInfo[index]['revelation_place'] ?? "".capitalizeFirst)}"
                                    .capitalizeFirst,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${(allChaptersInfo[index]['name_arabic'] ?? "")}"
                                    .capitalizeFirst,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                ayahCount[index].toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const Gap(5),
                          if (homePageController.selectForPlaylistMode.value ==
                              false)
                            getPopUpButton(audioController, index, context,
                                currentPlaylist),
                          if (homePageController.selectForPlaylistMode.value ==
                              true)
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Checkbox(
                                value: homePageController.containsInPlaylist(
                                    audioController.currentReciterModel.value,
                                    index),
                                onChanged: (value) {
                                  if (value == true) {
                                    homePageController.addToPlaylist(
                                      audioController.currentReciterModel.value,
                                      index,
                                    );
                                  } else {
                                    homePageController.removeToPlaylist(
                                        audioController
                                            .currentReciterModel.value,
                                        index);
                                  }
                                },
                              ),
                            ),
                          if (homePageController.selectForPlaylistMode.value ==
                              true)
                            const Gap(8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> showPopUpForQuranWithTajweedText(
      BuildContext context, int index, int ayahStart) {
    return showModalBottomSheet(
      showDragHandle: false,
      scrollControlDisabledMaxHeightRatio: 0.9,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7),
          topRight: Radius.circular(7),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            initialChildSize: 0.95,
            minChildSize: 0.75,
            maxChildSize: 0.95,
            expand: true,
            snap: true,
            builder: (context, scrollController) {
              return Stack(
                children: [
                  ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.only(
                        top: 40, bottom: 50, left: 10, right: 10),
                    itemCount: (ayahCount[(index)] / 10).ceil(),
                    itemBuilder: (context, index) {
                      int currentAyahCount = ayahCount[index];
                      int start = index * 10 + 1;
                      int end = (index + 1) * 10;
                      if (end > currentAyahCount) {
                        end = currentAyahCount;
                      }

                      List<InlineSpan> listOfAyahsSpanText = [];

                      for (int currentAyahNumber = start;
                          currentAyahNumber <= end;
                          currentAyahNumber++) {
                        listOfAyahsSpanText.addAll(
                          getTajweedTexSpan(
                            quranDB.get(
                              "uthmani_tajweed/${ayahStart + currentAyahNumber}",
                              defaultValue: "",
                            ),
                          ),
                        );
                      }

                      return Text.rich(
                        TextSpan(children: listOfAyahsSpanText),
                        style: TextStyle(
                          fontSize: universalController.fontSizeArabic.value,
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close)),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  void addSelectedDataToPlayList(BuildContext context) async {
    await homePageController.saveToPlayList();
    homePageController.reloadPlayList();
    widget.tabController.jumpToPage(2);
    toastification.show(
      context: context,
      title: const Text("Added to Playlist"),
      autoCloseDuration: const Duration(seconds: 2),
      type: ToastificationType.success,
    );
  }

  PopupMenuButton<String> getPopUpButton(AudioController audioController,
      int index, BuildContext context, PlayListModel currentPlayModel) {
    final box = Hive.box('play_list');
    List<PlayListModel> favoriteListModel = [];
    List<String> favoriteList =
        List<String>.from(box.get("Favorite", defaultValue: []));
    bool isExitsInFavorite = false;

    for (String favorite in favoriteList) {
      final model = PlayListModel.fromJson(favorite);
      favoriteListModel.add(model);
      if ((model.reciter.name == currentPlayModel.reciter.name &&
              model.reciter.link == currentPlayModel.reciter.link) &&
          model.surahNumber == currentPlayModel.surahNumber) {
        isExitsInFavorite = true;
      }
    }

    return PopupMenuButton(
      borderRadius: BorderRadius.circular(7),
      onSelected: (value) async {
        if (value == "Favorite") {
          await addOrRemoveFavorite(
              favoriteListModel, isExitsInFavorite, currentPlayModel, context);
        } else if (value == "Playlist") {
          List<String> playListName =
              List<String>.from(Hive.box("play_list").keys.toList());
          await showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                insetPadding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Column(
                    children: [
                      const Gap(10),
                      const Text(
                        "Add to",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: playListName.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              minTileHeight: 50,
                              title: Text(playListName[index]),
                              onTap: () async {
                                homePageController.nameOfEditingPlaylist.value =
                                    playListName[index];
                                List<PlayListModel> playModelsList =
                                    getPlayList(playListName[index]);
                                bool isAlreadyExits = false;
                                for (var element in playModelsList) {
                                  if ((element.reciter.name ==
                                              currentPlayModel.reciter.name &&
                                          element.reciter.link ==
                                              currentPlayModel.reciter.link) &&
                                      element.surahNumber ==
                                          currentPlayModel.surahNumber) {
                                    isAlreadyExits = true;
                                    break;
                                  }
                                }
                                if (isAlreadyExits) {
                                  toastification.show(
                                    context: context,
                                    title: const Text("Already Exits"),
                                    type: ToastificationType.info,
                                    autoCloseDuration:
                                        const Duration(seconds: 2),
                                  );
                                } else {
                                  playModelsList.add(currentPlayModel);
                                  homePageController.selectedForPlaylist.value =
                                      playModelsList;
                                  homePageController.saveToPlayList();
                                  homePageController.reloadPlayList();
                                  Navigator.pop(context);
                                  toastification.show(
                                    context: context,
                                    title: Text(
                                      "Successfully added to ${playListName[index]}",
                                    ),
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                    type: ToastificationType.success,
                                  );
                                }
                              },
                              trailing: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 15,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: "Favorite",
            child: Row(
              children: [
                Icon(
                  Icons.favorite_rounded,
                  color: isExitsInFavorite ? Colors.green : null,
                ),
                const Gap(7),
                Text(
                    "${isExitsInFavorite ? "Remove form" : "Add to"} Favorite"),
              ],
            ),
          ),
          const PopupMenuItem(
            value: "Playlist",
            child: Row(
              children: [
                Icon(Icons.playlist_add_rounded),
                Gap(7),
                Text("Add to Playlist"),
              ],
            ),
          ),
        ];
      },
      child: Container(
        height: 40,
        width: 20,
        decoration: BoxDecoration(
          color: Colors.grey.shade600.withValues(
            alpha: 0.2,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Icon(
          Icons.more_vert,
          size: 18,
        ),
      ),
    );
  }

  Future<void> addOrRemoveFavorite(
      List<PlayListModel> favoriteListModel,
      bool isExitsInFavorite,
      PlayListModel currentPlayModel,
      BuildContext context) async {
    homePageController.nameOfEditingPlaylist.value = "Favorite";
    homePageController.selectedForPlaylist.value = favoriteListModel;
    if (isExitsInFavorite) {
      homePageController.selectedForPlaylist.removeWhere((element) =>
          (element.reciter.name == currentPlayModel.reciter.name &&
              element.reciter.link == currentPlayModel.reciter.link) &&
          element.surahNumber == currentPlayModel.surahNumber);
    } else {
      homePageController.selectedForPlaylist.add(currentPlayModel);
    }
    await homePageController.saveToPlayList();
    homePageController.reloadPlayList();
    setState(() {});

    // Add to favorite
    toastification.show(
      context: context,
      title:
          Text("${isExitsInFavorite ? "Removed form" : "Added to"} Favorite"),
      autoCloseDuration: const Duration(seconds: 2),
      type: ToastificationType.success,
    );
  }

  List<PlayListModel> getPlayList(String playListName) {
    final box = Hive.box("play_list");
    List<PlayListModel> playlistModels = [];
    List<String> rawPlayModelsList =
        List<String>.from(box.get(playListName, defaultValue: []));

    for (String favorite in rawPlayModelsList) {
      final model = PlayListModel.fromJson(favorite);
      playlistModels.add(model);
    }
    return playlistModels;
  }
}

Widget getPlayButton(
  int index,
  AudioController audioController, {
  bool relatedWithAyah = false,
  int? surahNumber, // only if relatedWithAyah is true
  int? indexOfAyahInSurah,
}) {
  return Obx(
    () {
      bool isPlaying = audioController.currentSurahNumber.value == index &&
          audioController.isPlaying.value == true;
      bool isLoading = audioController.currentSurahNumber.value == index &&
          audioController.isLoading.value;
      bool isLoadANewOne = (audioController.isPlaying.value == true ||
              audioController.isLoading.value == true) &&
          audioController.currentSurahNumber.value != index;
      bool resumeOrPlay = audioController.isPlaying.value == false &&
          audioController.currentSurahNumber.value == index;
      bool playNewOneFirstTime = audioController.isPlaying.value == false &&
          audioController.currentSurahNumber.value != index;

      if (relatedWithAyah) {
        isPlaying =
            audioController.currentPlayingAyah.value == indexOfAyahInSurah &&
                audioController.isPlaying.value == true &&
                audioController.currentSurahNumber.value == surahNumber;

        return IconButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0),
            iconColor: Colors.green.shade600,
          ),
          onPressed: () {
            if (isPlaying &&
                audioController.currentPlayingAyah.value ==
                    indexOfAyahInSurah) {
              ManageQuranAudio.audioPlayer.pause();
              return;
            } else if (isPlaying &&
                audioController.currentPlayingAyah.value !=
                    indexOfAyahInSurah) {
              ManageQuranAudio.audioPlayer
                  .seek(Duration.zero, index: indexOfAyahInSurah);
              return;
            } else if (isPlaying == false) {
              if (audioController.currentPlayingAyah.value ==
                      indexOfAyahInSurah &&
                  audioController.currentSurahNumber.value == surahNumber) {
                ManageQuranAudio.audioPlayer.play();
                return;
              } else if (audioController.currentPlayingAyah.value !=
                      indexOfAyahInSurah &&
                  audioController.isReadyToControl.value == false) {
                // play A new one
                audioController.currentSurahNumber.value = surahNumber ?? 0;
                audioController.totalAyah.value = ayahCount[surahNumber ?? 0];
                ManageQuranAudio.playMultipleAyahAsPlayList(
                  surahNumber: surahNumber ?? 0,
                  reciter: audioController.currentReciterModel.value,
                  startOn: indexOfAyahInSurah,
                );
                return;
              } else if (surahNumber !=
                  audioController.currentSurahNumber.value) {
                // play A new one at first time
                audioController.currentSurahNumber.value = surahNumber ?? 0;
                audioController.totalAyah.value = ayahCount[surahNumber ?? 0];
                ManageQuranAudio.playMultipleAyahAsPlayList(
                  surahNumber: surahNumber ?? 0,
                  reciter: audioController.currentReciterModel.value,
                  startOn: indexOfAyahInSurah,
                );
                return;
              }
            }
            audioController.currentSurahNumber.value = surahNumber ?? 0;
            audioController.totalAyah.value = ayahCount[surahNumber ?? 0];
            ManageQuranAudio.playMultipleAyahAsPlayList(
              surahNumber: surahNumber ?? 0,
              reciter: audioController.currentReciterModel.value,
              startOn: indexOfAyahInSurah,
            );
          },
          icon: (isPlaying &&
                  audioController.currentPlayingAyah.value ==
                      indexOfAyahInSurah)
              ? const Icon(Icons.pause_rounded)
              : (isLoading &&
                      audioController.currentPlayingAyah.value ==
                          indexOfAyahInSurah)
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Colors.green,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(
                      Icons.play_arrow_rounded,
                    ),
        );
      }

      return IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Colors.green.shade800,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        tooltip: "Play or Pause",
        icon: (isPlaying)
            ? const Icon(Icons.pause_rounded)
            : (isLoading)
                ? CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    strokeWidth: 2,
                  )
                : const Icon(Icons.play_arrow_rounded),
        onPressed: () async {
          if (isPlaying) {
            await ManageQuranAudio.audioPlayer.pause();
          } else if (isLoadANewOne) {
            audioController.currentSurahNumber.value = index;
            audioController.totalAyah.value = ayahCount[index];
            await ManageQuranAudio.audioPlayer.stop();
            await ManageQuranAudio.playMultipleAyahAsPlayList(
              surahNumber: index,
              reciter: audioController.currentReciterModel.value,
            );
          } else if (resumeOrPlay) {
            if (audioController.isReadyToControl.value == false) {
              audioController.currentSurahNumber.value = index;
              await ManageQuranAudio.playMultipleAyahAsPlayList(
                surahNumber: index,
                reciter: audioController.currentReciterModel.value,
              );
            } else {
              await ManageQuranAudio.audioPlayer.play();
            }
          } else if (playNewOneFirstTime) {
            audioController.currentSurahNumber.value = index;
            audioController.totalAyah.value = ayahCount[index];
            await ManageQuranAudio.playMultipleAyahAsPlayList(
              surahNumber: index,
              reciter: audioController.currentReciterModel.value,
            );
          }
        },
      );
    },
  );
}
