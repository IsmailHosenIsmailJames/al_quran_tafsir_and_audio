import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/core/audio/controller/audio_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/functions/audio_tracking/model.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/home_page_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/notes/controller/notes_controller.dart';
import 'package:appwrite/models.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../auth/auth_controller/auth_controller.dart';
import '../../auth/auth_controller/login/login_page.dart';
import '../../functions/safe_substring.dart';
import '../home/tabs/collection_tab/controller/collection_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthController authController = Get.put(AuthController());
  final AudioController audioController = Get.find<AudioController>();
  final HomePageController homePageController = Get.put(HomePageController());
  bool backUpAsyncPlaylist = false;
  bool backUpAsyncGroup = false;
  bool backUpAsyncNote = false;

  @override
  void initState() {
    authController.loggedInUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        authController.loggedInUser.value == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Get the best experience by logging in ->',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'You can save your favorite playlist to the cloud. And continue listening from where you left off. No need to worry about losing your playlist. We got you covered.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Get.to(() => const LoginPage());
                          setState(() {});
                        },
                        iconAlignment: IconAlignment.end,
                        child: const Row(
                          children: [
                            Spacer(),
                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.fast_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : getUserUI(authController.loggedInUser.value!),
        const Gap(15),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Audio History',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Listened ${formatDuration(Duration(seconds: getTotalDurationInSeconds()))}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 30,
                width: 50,
                child: PopupMenuButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onSelected: (value) {
                      setState(() {
                        sortBy = value.toString();
                      });
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'surahIncreasing',
                          child: Text(
                            'Sort by increasing Surah Number',
                            style: TextStyle(
                              color: sortBy == 'surahIncreasing'
                                  ? Colors.green
                                  : null,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'surahDecreasing',
                          child: Text(
                            'Sort by decreasing Surah Number',
                            style: TextStyle(
                              color: sortBy == 'surahDecreasing'
                                  ? Colors.green
                                  : null,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'increasing',
                          child: Text(
                            'Sort by increasing surah duration',
                            style: TextStyle(
                              color:
                                  sortBy == 'increasing' ? Colors.green : null,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'decreasing',
                          child: Text(
                            'Sort by decreasing surah duration',
                            style: TextStyle(
                              color:
                                  sortBy == 'decreasing' ? Colors.green : null,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'increasingListened',
                          child: Text(
                            'Sort by increasing listened duration',
                            style: TextStyle(
                              color: sortBy == 'increasingListened'
                                  ? Colors.green
                                  : null,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'decreasingListened',
                          child: Text(
                            'Sort by decreasing listened duration',
                            style: TextStyle(
                              color: sortBy == 'decreasingListened'
                                  ? Colors.green
                                  : null,
                            ),
                          ),
                        ),
                      ];
                    }),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withValues(alpha: 0.05),
          ),
          child: StreamBuilder(
            stream: getPeriodicStream(),
            builder: (context, snapshot) {
              List<TrackingAudioModel> audioTrackingModelList =
                  getAudioTrackingModelList();
              return Column(
                children: List.generate(
                  audioTrackingModelList.length,
                  (index) {
                    TrackingAudioModel currentTrackingModel =
                        audioTrackingModelList[index];
                    Set<int> playedAyah = currentTrackingModel.playedAyah;
                    int ayahNumber =
                        ayahCount[currentTrackingModel.surahNumber];
                    bool isDone = playedAyah.length >= ayahNumber;
                    bool didNotPlayed =
                        currentTrackingModel.totalPlayedDurationInSeconds ==
                                0 &&
                            currentTrackingModel.playedAyah.isEmpty;
                    return getAudioHistoryOfSurah(
                        currentTrackingModel, didNotPlayed, context, isDone);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String sortBy = 'surahIncreasing';

  Padding getAudioHistoryOfSurah(TrackingAudioModel currentTrackingModel,
      bool didNotPlayed, BuildContext context, bool isDone) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            child: FittedBox(
              child: Text(
                (currentTrackingModel.surahNumber + 1).toString(),
              ),
            ),
          ),
          const Gap(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    allChaptersInfo[currentTrackingModel.surahNumber]
                            ['name_simple'] ??
                        '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(10),
                  (didNotPlayed)
                      ? const Text(
                          "Didn't played yet",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        )
                      : Text(
                          'Listened: ${formatDuration(Duration(seconds: currentTrackingModel.totalPlayedDurationInSeconds))} | Played ${currentTrackingModel.playedAyah.length} / ${ayahCount[currentTrackingModel.surahNumber]} ayahs',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75 -
                          ((isDone && didNotPlayed == false) ? 30 : 0),
                      child: LinearProgressIndicator(
                        value: currentTrackingModel.playedAyah.length /
                            ayahCount[currentTrackingModel.surahNumber],
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    const Gap(5),
                    if (isDone && didNotPlayed == false)
                      const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Stream<int> getPeriodicStream() async* {
    yield* Stream.periodic(const Duration(seconds: 5), (_) {
      return 1;
    }).asyncMap(
      (value) async => value,
    );
  }

  List<TrackingAudioModel> getAudioTrackingModelList() {
    List<TrackingAudioModel> toReturn = [];
    final box = Hive.box('audio_track');
    for (int key = 0; key < 114; key++) {
      final value = box.get(key);
      TrackingAudioModel? model = value != null
          ? TrackingAudioModel.fromMap(
              Map<String, dynamic>.from(value),
            )
          : null;
      model ??= TrackingAudioModel(
          surahNumber: key,
          lastReciterId: audioController.currentReciterModel.value.link,
          playedAyah: {},
          totalPlayedDurationInSeconds: 0);

      toReturn.add(model);
    }

    if (sortBy == 'surahIncreasing') {
      return toReturn;
    } else if (sortBy == 'surahDecreasing') {
      return toReturn.reversed.toList();
    } else if (sortBy == 'increasing') {
      toReturn.sort((a, b) => ayahCount[a.surahNumber].compareTo(
            ayahCount[b.surahNumber],
          ));
      return toReturn;
    } else if (sortBy == 'decreasing') {
      toReturn.sort((a, b) => ayahCount[b.surahNumber].compareTo(
            ayahCount[a.surahNumber],
          ));
      return toReturn;
    } else if (sortBy == 'increasingListened') {
      toReturn.sort((a, b) => a.totalPlayedDurationInSeconds.compareTo(
            b.totalPlayedDurationInSeconds,
          ));
      return toReturn;
    } else if (sortBy == 'decreasingListened') {
      toReturn.sort((a, b) => b.totalPlayedDurationInSeconds.compareTo(
            a.totalPlayedDurationInSeconds,
          ));
      return toReturn;
    }

    return toReturn;
  }

  int getTotalDurationInSeconds() {
    int totalDurationInSeconds = 0;
    getAudioTrackingModelList().forEach((element) {
      totalDurationInSeconds += element.totalPlayedDurationInSeconds;
    });
    return totalDurationInSeconds;
  }

  String formatDuration(Duration duration) {
    return '${duration.inHours}:${duration.inMinutes % 60}:${duration.inSeconds % 60}';
  }

  Widget getUserUI(User user) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Obx(
        () {
          final allPlaylist = homePageController.allPlaylistInDB.value;
          List<String> rawStringOfAllPlaylist = [];
          for (var element in allPlaylist) {
            rawStringOfAllPlaylist.add(element.toJson());
          }
          String? cloudPlayListString = Hive.box('cloud_play_list')
              .get('all_playlist', defaultValue: null);
          bool isBackedUpPlaylist =
              cloudPlayListString == jsonEncode(rawStringOfAllPlaylist);

          // Notes
          String? cloudNoteString =
              Hive.box('cloud_notes_db').get('all_notes', defaultValue: null);
          NotesController notesController = Get.put(NotesController());

          List<String> rawStringOfNotes = [];
          for (var element in notesController.notes.value) {
            rawStringOfNotes.add(element.toJson());
          }
          bool isBackedUpNote = cloudNoteString == jsonEncode(rawStringOfNotes);

          // Collections

          String? cloudCollectionString = Hive.box('cloud_collections_db')
              .get('all_collections', defaultValue: null);
          CollectionController collectionController =
              Get.put(CollectionController());
          List<String> rawStringOfCollection = [];
          for (var element in collectionController.collectionList.value) {
            rawStringOfCollection.add(element.toJson());
          }
          bool isBackedUpCollection =
              cloudCollectionString == jsonEncode(rawStringOfCollection);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Text(
                          user.email.substring(0, 2).toUpperCase(),
                        ),
                      ),
                      const Gap(10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            safeSubString(user.email, 25),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Gap(5),
                          Text(
                            'ID: ${user.$id}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey.shade400),
                          ),
                          SizedBox(
                            height: 30,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.only(right: 100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              onPressed: () async {
                                await authController.logout();
                                toastification.show(
                                  context: context,
                                  title: const Text('Successful'),
                                  description: const Text('Logout successful'),
                                  type: ToastificationType.success,
                                  autoCloseDuration: const Duration(seconds: 3),
                                );
                                setState(() {});
                              },
                              icon: const Icon(Icons.logout_rounded),
                              label: const Text('logout'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(10),
              const Text(
                'Backup changes to cloud',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(10),
              ListTile(
                minTileHeight: 50,
                leading: const Icon(
                  Icons.playlist_play_rounded,
                ),
                contentPadding: const EdgeInsets.all(5),
                horizontalTitleGap: 5,
                title: const Text('Click to Backup Playlists'),
                trailing: backUpAsyncPlaylist
                    ? const CircularProgressIndicator(strokeWidth: 3)
                    : isBackedUpPlaylist
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.backup,
                            color: Colors.green,
                          ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                tileColor: Colors.grey.withValues(alpha: 0.2),
                onTap: () async {
                  if (isBackedUpPlaylist) {
                    return;
                  }
                  showDataLoseAlertDialog(() async {
                    setState(() {
                      backUpAsyncPlaylist = true;
                    });
                    String? error =
                        await audioController.backupPlayList(allPlaylist);
                    setState(() {
                      backUpAsyncPlaylist = false;
                    });
                    if (error == null) {
                      toastification.show(
                        context: context,
                        title: const Text('Successful'),
                        description: const Text('Backup process successful'),
                        type: ToastificationType.success,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    } else {
                      toastification.show(
                        context: context,
                        title: const Text('Found issue'),
                        description: Text(error),
                        type: ToastificationType.error,
                        autoCloseDuration: const Duration(seconds: 5),
                      );
                    }
                  });
                },
              ),
              const Gap(10),
              ListTile(
                minTileHeight: 50,
                leading: const Icon(
                  Icons.bookmark_rounded,
                ),
                contentPadding: const EdgeInsets.all(5),
                horizontalTitleGap: 5,
                title: const Text('Click to Backup Groups'),
                trailing: backUpAsyncGroup
                    ? const CircularProgressIndicator(strokeWidth: 3)
                    : isBackedUpCollection
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.backup,
                            color: Colors.green,
                          ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                tileColor: Colors.grey.withValues(alpha: 0.2),
                onTap: () async {
                  if (isBackedUpCollection) {
                    return;
                  }
                  showDataLoseAlertDialog(() async {
                    setState(() {
                      backUpAsyncGroup = true;
                    });
                    CollectionController collectionController =
                        Get.put(CollectionController());

                    String? error = await homePageController.backupGroups(
                        collectionController.collectionList.value);
                    setState(() {
                      backUpAsyncGroup = false;
                    });
                    if (error == null) {
                      toastification.show(
                        context: context,
                        title: const Text('Successful'),
                        description: const Text('Backup process successful'),
                        type: ToastificationType.success,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    } else {
                      toastification.show(
                        context: context,
                        title: const Text('Found issue'),
                        description: Text(error),
                        type: ToastificationType.error,
                        autoCloseDuration: const Duration(seconds: 5),
                      );
                    }
                  });
                },
              ),
              const Gap(10),
              ListTile(
                minTileHeight: 50,
                leading: const Icon(
                  FluentIcons.notepad_24_filled,
                ),
                contentPadding: const EdgeInsets.all(5),
                horizontalTitleGap: 5,
                title: const Text('Click to Backup Notes'),
                trailing: backUpAsyncNote
                    ? const CircularProgressIndicator(strokeWidth: 3)
                    : isBackedUpNote
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.backup,
                            color: Colors.green,
                          ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                tileColor: Colors.grey.withValues(alpha: 0.2),
                onTap: () async {
                  if (isBackedUpNote) {
                    return;
                  }
                  showDataLoseAlertDialog(() async {
                    setState(() {
                      backUpAsyncNote = true;
                    });

                    NotesController notesController =
                        Get.put(NotesController());
                    notesController.onInit();
                    String? error = await homePageController
                        .backupNote(notesController.notes.value);
                    setState(() {
                      backUpAsyncNote = false;
                    });
                    if (error == null) {
                      toastification.show(
                        context: context,
                        title: const Text('Successful'),
                        description: const Text('Backup process successful'),
                        type: ToastificationType.success,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    } else {
                      toastification.show(
                        context: context,
                        title: const Text('Found issue'),
                        description: Text(error),
                        type: ToastificationType.error,
                        autoCloseDuration: const Duration(seconds: 5),
                      );
                    }
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }

  showDataLoseAlertDialog(Function function) {
    log('Called');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: const Text('You data will be replaced!'),
          content: const Text(
              'If you did backup your data previously, it will be replaced by the new data. We are working on more features for backup functionality. Do you want to continue?'),
          actions: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.close),
              label: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                function();
                Navigator.pop(context);
              },
              label: const Text('Continue'),
            )
          ],
        );
      },
    );
  }
}
