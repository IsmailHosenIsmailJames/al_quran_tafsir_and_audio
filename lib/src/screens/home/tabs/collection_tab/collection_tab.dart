import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/core/audio/play_quran_audio.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/home_page_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/model/play_list_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/universal_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/create_new_collection.dart/add_new_ayah.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/create_new_collection.dart/create_new_collection_page.dart';
import 'package:al_quran_tafsir_and_audio/src/theme/theme_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/audio/controller/audio_controller.dart';
import '../../../notes/all_notes.dart';

class CollectionTab extends StatefulWidget {
  final PageController tabController;
  const CollectionTab({super.key, required this.tabController});

  @override
  State<CollectionTab> createState() => _CollectionTabState();
}

class _CollectionTabState extends State<CollectionTab> {
  final HomePageController homePageController = Get.put(HomePageController());
  final AudioController audioController = Get.put(AudioController());
  final themeController = Get.find<AppThemeData>();
  final UniversalController universalController = Get.find();
  late final PageController pageController = PageController(
    initialPage: universalController.collectionTabIndex.value,
  );

  CollectionController collectionController = Get.put(CollectionController());
  List<int> expandedList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        getTopTabController(width),
        Obx(
          () {
            final allPlayList = homePageController.allPlaylistInDB.value;
            return Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (value) {
                  log(value.toString());
                  universalController.collectionTabIndex.value = value;
                },
                children: [
                  getGroupsTab(),
                  allPlayList.isEmpty
                      ? getEmptyPlaylistView(context)
                      : getPlayListView(allPlayList),
                  const AllNotes(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Container getTopTabController(double width) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(
          alpha: 0.3,
        ),
      ),
      height: 30,
      child: Obx(
        () {
          int collectionTabIndex = universalController.collectionTabIndex.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: collectionTabIndex == 0
                        ? Colors.green.shade700
                        : Colors.transparent,
                    foregroundColor: collectionTabIndex == 0
                        ? Colors.white
                        : Colors.green.shade700,
                    iconColor: collectionTabIndex == 0
                        ? Colors.white
                        : Colors.green.shade700,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    collectionTabIndex = 0;
                    pageController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(FluentIcons.bookmark_24_filled),
                      const Gap(5),
                      Text(
                        'Groups'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: collectionTabIndex == 1
                        ? Colors.green.shade700
                        : Colors.transparent,
                    foregroundColor: collectionTabIndex == 1
                        ? Colors.white
                        : Colors.green.shade700,
                    iconColor: collectionTabIndex == 1
                        ? Colors.white
                        : Colors.green.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    collectionTabIndex = 1;
                    pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.playlist_play_rounded),
                      const Gap(5),
                      Text(
                        'Playlist'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: collectionTabIndex == 2
                        ? Colors.green.shade700
                        : Colors.transparent,
                    foregroundColor: collectionTabIndex == 2
                        ? Colors.white
                        : Colors.green.shade700,
                    iconColor: collectionTabIndex == 2
                        ? Colors.white
                        : Colors.green.shade700,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    collectionTabIndex = 3;
                    pageController.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(FluentIcons.notepad_24_filled),
                      const Gap(5),
                      Text(
                        'Notes'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ListView getPlayListView(List<AllPlayListModel> allPlayList) {
    return ListView(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 100),
      children: <Widget>[
            Row(
              children: [
                Text('Total PlayList: ${allPlayList.length}'),
                const Spacer(),
                SizedBox(
                  height: 25,
                  child: ElevatedButton.icon(
                    onPressed: createANewPlayList,
                    icon: const Icon(Icons.add),
                    label: const Text('Create New PlayList'),
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
  }

  Center getEmptyPlaylistView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 75,
            width: 75,
            child: Obx(
              () {
                bool isDark = themeController.themeModeName.value == 'dark' ||
                    (themeController.themeModeName.value == 'system' &&
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark);

                return Image(
                  image: const AssetImage(
                    'assets/empty-folder.png',
                  ),
                  color: isDark ? Colors.white : Colors.black,
                );
              },
            ),
          ),
          const Gap(10),
          Text('No PlayList found'.tr),
          const Gap(10),
          ElevatedButton.icon(
            onPressed: createANewPlayList,
            icon: const Icon(Icons.add),
            label: Text(
              'Create PlayList'.tr,
            ),
          ),
        ],
      ),
    );
  }

  ListView getGroupsTab() {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 5,
        left: 5,
        right: 5,
        bottom: 100,
      ),
      itemCount: collectionController.collectionList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await Get.to(
                      () => const CreateNewCollectionPage(
                        previousData: null,
                      ),
                    );
                    setState(() {});
                  },
                  child: Text('Create New Group'.tr),
                ),
              ),
              if (collectionController.collectionList.isEmpty)
                Gap(MediaQuery.of(context).size.height * 0.3),
              if (collectionController.collectionList.isEmpty)
                Text('No groups found'.tr),
            ],
          );
        }
        CollectionInfoModel currentCollection =
            collectionController.collectionList[index - 1];
        List<String> ayahKey = currentCollection.ayahs ?? [];
        return Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            border: Border.all(
              color: Colors.green.withValues(
                alpha: 0.3,
              ),
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      currentCollection.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (currentCollection.description != null) const Gap(7),
                    if (currentCollection.description != null)
                      const Text('Description',
                          style: TextStyle(
                            color: Colors.grey,
                          )),
                    if (currentCollection.description != null)
                      Text(
                        currentCollection.description!,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    const Gap(10),
                  ],
                ),
              ),
              const Gap(7),
              const Text(
                'Ayahs',
                style: TextStyle(color: Colors.grey),
              ),
              const Gap(5),
              Container(
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  children: List.generate(ayahKey.length, (i) {
                    int surahNumber = int.parse(ayahKey[i].split(':')[0]);
                    int ayahNumber = int.parse(ayahKey[i].split(':')[1]);
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => AddNewAyahForCollection(
                            selectedAyahNumber: ayahNumber,
                            selectedSurahNumber: surahNumber,
                            surahName: allChaptersInfo[surahNumber]
                                ['name_simple'],
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              radius: 15,
                              child: FittedBox(child: Text('${i + 1}')),
                            ),
                          ),
                          const Gap(10),
                          Text(
                            "${surahNumber + 1}. ${allChaptersInfo[surahNumber]["name_simple"]} ( ${ayahNumber + 1} )",
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward,
                            size: 16,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                      ),
                      onPressed: () async {
                        collectionController.editingCollection.value =
                            collectionController.collectionList[index - 1];
                        await Get.to(
                          () => CreateNewCollectionPage(
                            previousData:
                                collectionController.editingCollection.value,
                          ),
                        );
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.green,
                      ),
                    ),
                    const Gap(10),
                    IconButton(
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Are you sure?'),
                              content: const Text(
                                  "Once deleted, it can't be recovered"),
                              actions: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text('Cancel'),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    collectionController.collectionList
                                        .removeAt(index - 1);
                                    Hive.box('collections_db').delete(
                                      currentCollection.id,
                                    );
                                    Navigator.pop(context);
                                    setState(() {});
                                    toastification.show(
                                      context: context,
                                      title: const Text('Deleted'),
                                      type: ToastificationType.success,
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Delete'),
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
                          const Text('Total: '),
                          Text(
                            '${currentPlayList.length}',
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
                            title: const Text('Under Development'),
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add, color: Colors.green),
                            Gap(7),
                            Text('Add New '),
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
                            Text('Edit Name'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () async {
                          try {
                            Hive.box('play_list').delete(playListKey);

                            homePageController.reloadPlayList();

                            toastification.show(
                              context: context,
                              title: const Text('Deleted'),
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
                            Text('Delete Playlist'),
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
                  'Name of the PlayList',
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
                      hintText: 'Enter the name of the PlayList',
                      border: InputBorder.none,
                    ),
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name of the PlayList';
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
                                'PlayList already exists or name is not allowed'),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                        } else {
                          try {
                            List<PlayListModel> allPlayList = homePageController
                                .allPlaylistInDB.value[index].playList;
                            await Hive.box('play_list').delete(playlistKey);
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
                              title: const Text('Saved changes'),
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
                              const Text('Empty PlayList name is not allowed'),
                          type: ToastificationType.error,
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                      }
                    },
                    icon: const Icon(Icons.done),
                    label: const Text(
                      'Save Changes',
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
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
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
                                      '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  'Total Ayah: ${ayahCount[playListModel.surahNumber]}',
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
                                      Text('Delete'),
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
                  child: Text('Empty PlayList'),
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
        tooltip: 'Play',
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
        bool isDark = themeController.themeModeName.value == 'dark' ||
            (themeController.themeModeName.value == 'system' &&
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
                Text(
                  'Name of the PlayList'.tr,
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
                    decoration: InputDecoration(
                      hintText: 'Enter the name of the PlayList'.tr,
                      border: InputBorder.none,
                    ),
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name of the PlayList'.tr;
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
                            title: Text(
                                'PlayList already exists or name is not allowed'
                                    .tr),
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
                          title: Text('Empty PlayList name is not allowed'.tr),
                          type: ToastificationType.error,
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: Text(
                      'Create PlayList'.tr,
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
