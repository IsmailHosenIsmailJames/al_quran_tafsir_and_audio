import 'dart:convert';

import 'package:al_quran_tafsir_and_audio/src/auth/auth_controller/auth_controller.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../api/appwrite/config.dart';
import '../../../screens/home/controller/model/play_list_model.dart';
import '../resources/quran_com/all_recitations.dart';
import '../resources/recitation_info_model.dart';

class AudioController extends GetxController {
  static final box = Hive.box('user_db');
  RxInt currentSurahNumber = (-1).obs;
  RxInt currentReciterIndex = (0).obs;
  RxInt currentPlayListIndex = (0).obs;
  RxInt setupSelectedReciterIndex = (0).obs;
  RxBool isFullScreenMode = false.obs;
  RxInt totalAyah = (0).obs;

  RxInt currentPlayingAyah = (0).obs;
  Rx<ReciterInfoModel> currentReciterModel = ReciterInfoModel.fromJson(
    box.get(
      'default_reciter',
      defaultValue: jsonEncode(recitationsListOfQuranCom[0]),
    ),
  ).obs;
  RxBool isPlaying = false.obs;
  Rx<Duration> progress = const Duration().obs;
  Rx<Duration> totalDuration = const Duration().obs;
  Rx<Duration> bufferPosition = const Duration().obs;
  Rx<Duration> totalPosition = const Duration().obs;
  RxDouble speed = 1.0.obs;
  RxBool isStreamRegistered = false.obs;
  RxBool isLoading = false.obs;
  RxBool isSurahAyahMode = false.obs;
  RxBool isReadyToControl = false.obs;
  RxBool isPlayingCompleted = false.obs;

  Future<String?> backupPlayList(List<AllPlayListModel> allPlaylistInDB) async {
    try {
      if (allPlaylistInDB.isEmpty) {
        return 'No PlayList found';
      }

      List<String> rawPlaylistData = [];
      for (var playList in allPlaylistInDB) {
        rawPlaylistData.add(playList.toJson());
      }
      String rawJson = jsonEncode(rawPlaylistData);
      final db = Databases(AppWriteConfig.client);

      try {
        final AuthController authController = Get.find<AuthController>();
        String id = authController.loggedInUser.value!.$id;
        if (Hive.box('cloud_play_list').keys.isNotEmpty) {
          await db.updateDocument(
            databaseId: authController.databaseID,
            collectionId: authController.collectionIDPlayList,
            documentId: id,
            data: {
              'all_playlist_data': rawJson,
            },
          );
          await Hive.box('cloud_play_list').put('all_playlist', rawJson);
        } else {
          await db.createDocument(
            databaseId: authController.databaseID,
            collectionId: authController.collectionIDPlayList,
            documentId: id,
            data: {
              'all_playlist_data': rawJson,
            },
          );
          await Hive.box('cloud_play_list').put('all_playlist', rawJson);
        }
      } on AppwriteException catch (e) {
        return e.message;
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
