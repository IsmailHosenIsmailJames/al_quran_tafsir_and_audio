import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/core/audio/play_quran_audio.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/home_page_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/model/play_list_model.dart';
import 'package:al_quran_tafsir_and_audio/src/theme/theme_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../core/audio/controller/audio_controller.dart';

class PlayListTab extends StatefulWidget {
  final PageController tabController;
  const PlayListTab({super.key, required this.tabController});

  @override
  State<PlayListTab> createState() => _PlayListTabState();
}

class _PlayListTabState extends State<PlayListTab> {
  final HomePageController homePageController = Get.put(HomePageController());
  final AudioController audioController = Get.put(AudioController());
  final themeController = Get.find<AppThemeData>();
  List<int> expandedList = [];
  @override
  void initState() {
    super.initState();
  }

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(
              alpha: 0.3,
            ),
          ),
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tabIndex == 0
                        ? Colors.green.shade700
                        : Colors.transparent,
                    foregroundColor:
                        tabIndex == 0 ? Colors.white : Colors.green.shade700,
                    iconColor:
                        tabIndex == 0 ? Colors.white : Colors.green.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      tabIndex = 0;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.playlist_play_rounded),
                      Gap(10),
                      Text(
                        "Playlist",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tabIndex == 1
                        ? Colors.green.shade700
                        : Colors.transparent,
                    foregroundColor:
                        tabIndex == 1 ? Colors.white : Colors.green.shade700,
                    iconColor:
                        tabIndex == 1 ? Colors.white : Colors.green.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      tabIndex = 1;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(FluentIcons.bookmark_24_filled),
                      Gap(10),
                      Text(
                        "Groups",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: tabIndex == 0
              ? Obx(
                  () {
                    final allPlayList =
                        homePageController.allPlaylistInDB.value;
                    return allPlayList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 75,
                                  width: 75,
                                  child: Obx(
                                    () {
                                      bool isDark =
                                          themeController.themeModeName.value ==
                                                  "dark" ||
                                              (themeController.themeModeName
                                                          .value ==
                                                      "system" &&
                                                  MediaQuery.of(context)
                                                          .platformBrightness ==
                                                      Brightness.dark);

                                      return Image(
                                        image: const AssetImage(
                                          "assets/empty-folder.png",
                                        ),
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      );
                                    },
                                  ),
                                ),
                                const Gap(10),
                                const Text("No PlayList found"),
                                const Gap(10),
                                ElevatedButton.icon(
                                  onPressed: createANewPlayList,
                                  icon: const Icon(Icons.add),
                                  label: const Text(
                                    "Create PlayList",
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 5, bottom: 100),
                            children: <Widget>[
                                  Row(
                                    children: [
                                      Text(
                                          "Total PlayList: ${allPlayList.length}"),
                                      const Spacer(),
                                      SizedBox(
                                        height: 25,
                                        child: ElevatedButton.icon(
                                          onPressed: createANewPlayList,
                                          icon: const Icon(Icons.add),
                                          label:
                                              const Text("Create New PlayList"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ] +
                                List<Widget>.generate(
                                  allPlayList.length,
                                  (index) {
                                    return getPlayListCards(allPlayList, index);
                                  },
                                ),
                          );
                  },
                )
              : Center(
                  child: Text("Under Development"),
                ),
        ),
      ],
    );
  }

  Card getPlayListCards(List<AllPlayListModel> allPlayList, int index) {
    String playListKey = allPlayList[index].name;
    final currentPlayList = allPlayList[index].playList;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  if (expandedList.contains(index)) {
                    expandedList.remove(index);
                  } else {
                    expandedList.add(index);
                  }
                });
              },
              child: Row(
                children: [
                  // SizedBox(height: 34, width: 34, child: getPlayButton(index)),
                  const Gap(8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playListKey,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Text("Total: "),
                          Text(
                            "${currentPlayList.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(
                    expandedList.contains(index)
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          homePageController.selectedForPlaylist.value =
                              currentPlayList;
                          homePageController.selectForPlaylistMode.value = true;
                          homePageController.nameOfEditingPlaylist.value =
                              playListKey;
                          widget.tabController.jumpToPage(1);
                          toastification.show(
                            context: context,
                            title: const Text("Under Development"),
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add, color: Colors.green),
                            Gap(7),
                            Text("Add New "),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          TextEditingController nameController =
                              TextEditingController(text: playListKey);
                          getEditPlaylistPopUp(
                              context, nameController, playListKey, index);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.edit, color: Colors.green),
                            Gap(7),
                            Text("Edit Name"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () async {
                          try {
                            Hive.box("play_list").delete(playListKey);

                            homePageController.reloadPlayList();

                            toastification.show(
                              context: context,
                              title: const Text("Deleted"),
                              autoCloseDuration: const Duration(seconds: 2),
                            );
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            Gap(7),
                            Text("Delete Playlist"),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            animatedExpandedList(index, currentPlayList),
          ],
        ),
      ),
    );
  }

  Future<dynamic> getEditPlaylistPopUp(BuildContext context,
      TextEditingController nameController, String playlistKey, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Name of the PlayList",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Gap(10),
                Container(
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 2,
                    bottom: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter the name of the PlayList",
                      border: InputBorder.none,
                    ),
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the name of the PlayList";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (nameController.text.isNotEmpty) {
                        if (Hive.box('play_list')
                            .containsKey(nameController.text.trim())) {
                          toastification.show(
                            context: context,
                            title: const Text(
                                "PlayList already exists or name is not allowed"),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                        } else {
                          try {
                            List<PlayListModel> allPlayList = homePageController
                                .allPlaylistInDB.value[index].playList;
                            await Hive.box("play_list").delete(playlistKey);
                            List<String> rawData = [];
                            for (var e in allPlayList) {
                              rawData.add(e.toJson());
                            }
                            await Hive.box('play_list')
                                .put(nameController.text.trim(), rawData);
                            homePageController.reloadPlayList();
                            Navigator.pop(context);
                            toastification.show(
                              context: context,
                              title: const Text("Saved changes"),
                              autoCloseDuration: const Duration(seconds: 2),
                            );
                          } catch (e) {
                            log(e.toString());
                          }
                        }
                      } else {
                        toastification.show(
                          context: context,
                          title:
                              const Text("Empty PlayList name is not allowed"),
                          type: ToastificationType.error,
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                      }
                    },
                    icon: const Icon(Icons.done),
                    label: const Text(
                      "Save Changes",
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AnimatedContainer animatedExpandedList(
      int index, List<PlayListModel>? currentPlayList) {
    ScrollController scrollController = ScrollController();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10.0),
      height: expandedList.contains(index) ? 300 : 0,
      child: (expandedList.contains(index))
          ? (currentPlayList?.length ?? 0) > 0
              ? Scrollbar(
                  controller: scrollController,
                  interactive: true,
                  radius: const Radius.circular(10),
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: currentPlayList?.length ?? 0,
                    itemBuilder: (context, i) {
                      final playListModel = currentPlayList![i];
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8, top: 4, bottom: 4),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playListModel.reciter.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  allChaptersInfo[playListModel.surahNumber]
                                          ['name_simple'] ??
                                      "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  "Total Ayah: ${ayahCount[playListModel.surahNumber]}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 34,
                              width: 34,
                              child: getPlayButtonOnPlaylistList(
                                  playListModel, i, index, currentPlayList),
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () {
                                    homePageController
                                            .nameOfEditingPlaylist.value =
                                        homePageController
                                            .allPlaylistInDB.value[index].name;
                                    homePageController
                                            .selectedForPlaylist.value =
                                        homePageController.allPlaylistInDB
                                            .value[index].playList;
                                    homePageController.selectedForPlaylist
                                        .removeAt(i);
                                    homePageController.saveToPlayList();
                                    homePageController.reloadPlayList();
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      Gap(7),
                                      Text("Delete"),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text("Empty PlayList"),
                )
          : const SizedBox(),
    );
  }

  Widget getPlayButtonOnPlaylistList(PlayListModel playListModel, int i,
      int index, List<PlayListModel> currentPlayList) {
    return Obx(
      () => IconButton(
        icon: (audioController.currentSurahNumber.value ==
                    playListModel.surahNumber &&
                audioController.isPlaying.value == true &&
                audioController.currentPlayListIndex.value == index)
            ? const Icon(Icons.pause)
            : (audioController.currentSurahNumber.value ==
                        playListModel.surahNumber &&
                    audioController.isLoading.value &&
                    audioController.currentPlayListIndex.value == index)
                ? CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    strokeWidth: 2,
                  )
                : const Icon(Icons.play_arrow),
        tooltip: "Play",
        style: IconButton.styleFrom(
          side: const BorderSide(),
          padding: EdgeInsets.zero,
        ),
        onPressed: () async {
          if (audioController.isPlaying.value == true &&
              audioController.currentSurahNumber.value ==
                  playListModel.surahNumber) {
            await ManageQuranAudio.audioPlayer.pause();
          } else if ((audioController.isPlaying.value == true ||
                  audioController.isLoading.value == true) &&
              audioController.currentSurahNumber.value !=
                  playListModel.surahNumber) {
            audioController.currentSurahNumber.value =
                playListModel.surahNumber;
            audioController.currentPlayListIndex.value = index;
            audioController.totalAyah.value =
                ayahCount[playListModel.surahNumber];
            audioController.currentPlayListIndex.value == index;
            await ManageQuranAudio.audioPlayer.stop();
            await ManageQuranAudio.playMultipleAyahAsPlayList(
              surahNumber: index,
              reciter: audioController.currentReciterModel.value,
            );
          } else if (audioController.isPlaying.value == false &&
              audioController.currentSurahNumber.value ==
                  playListModel.surahNumber) {
            if (audioController.isReadyToControl.value == false) {
              audioController.totalAyah.value =
                  ayahCount[playListModel.surahNumber];
              audioController.currentSurahNumber.value =
                  playListModel.surahNumber;
              audioController.currentPlayListIndex.value == index;
              await ManageQuranAudio.playMultipleAyahAsPlayList(
                surahNumber: index,
                reciter: audioController.currentReciterModel.value,
              );
            } else {
              await ManageQuranAudio.audioPlayer.play();
            }
          } else if (audioController.isPlaying.value == false &&
              audioController.currentSurahNumber.value !=
                  playListModel.surahNumber) {
            audioController.currentPlayListIndex.value = index;
            audioController.currentSurahNumber.value =
                playListModel.surahNumber;
            audioController.totalAyah.value =
                ayahCount[playListModel.surahNumber];
            await ManageQuranAudio.playMultipleAyahAsPlayList(
              surahNumber: index,
              reciter: audioController.currentReciterModel.value,
            );
          }
        },
      ),
    );
  }

  createANewPlayList() async {
    showDialog(
      context: context,
      builder: (context) {
        final playListController = TextEditingController();
        bool isDark = themeController.themeModeName.value == "dark" ||
            (themeController.themeModeName.value == "system" &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);

        return Dialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Name of the PlayList",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Gap(10),
                Container(
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 2,
                    bottom: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: TextFormField(
                    controller: playListController,
                    decoration: const InputDecoration(
                      hintText: "Enter the name of the PlayList",
                      border: InputBorder.none,
                    ),
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the name of the PlayList";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (playListController.text.isNotEmpty) {
                        if (Hive.box('play_list')
                            .containsKey(playListController.text.trim())) {
                          toastification.show(
                            context: context,
                            title: const Text(
                                "PlayList already exists or name is not allowed"),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                        } else {
                          Navigator.pop(context);
                          homePageController.selectForPlaylistMode.value = true;
                          homePageController.nameOfEditingPlaylist.value =
                              playListController.text.trim();
                          widget.tabController.jumpToPage(1);
                        }
                      } else {
                        toastification.show(
                          context: context,
                          title:
                              const Text("Empty PlayList name is not allowed"),
                          type: ToastificationType.error,
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                      "Create PlayList",
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
