import 'dart:convert';

import 'package:al_quran_tafsir_and_audio/src/api/appwrite/config.dart';
import 'package:al_quran_tafsir_and_audio/src/auth/auth_controller/auth_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/controller/model/play_list_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/notes/models/notes_model.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/audio/resources/recitation_info_model.dart';

class HomePageController extends GetxController {
  RxBool selectForPlaylistMode = false.obs;
  RxList<PlayListModel> selectedForPlaylist = <PlayListModel>[].obs;
  RxList<AllPlayListModel> allPlaylistInDB = <AllPlayListModel>[].obs;
  RxString nameOfEditingPlaylist = ''.obs;

  @override
  void onInit() {
    reloadPlayList();
    super.onInit();
  }

  void addToPlaylist(ReciterInfoModel reciterInfoModel, int surahNumber) {
    selectedForPlaylist.add(
      PlayListModel(
        reciter: reciterInfoModel,
        surahNumber: surahNumber,
      ),
    );
  }

  void removeToPlaylist(ReciterInfoModel reciterInfoModel, int surahNumber) {
    selectedForPlaylist.removeWhere(
      (element) => ((element.reciter.name == reciterInfoModel.name &&
              element.reciter.link == reciterInfoModel.link) &&
          element.surahNumber == surahNumber),
    );
  }

  bool containsInPlaylist(ReciterInfoModel reciterInfoModel, int surahNumber) {
    return selectedForPlaylist.any(
      (element) =>
          (element.reciter.name == reciterInfoModel.name &&
              element.reciter.link == reciterInfoModel.link) &&
          element.surahNumber == surahNumber,
    );
  }

  Future<void> saveToPlayList() async {
    List<String> playList = [];
    for (var playListModel in selectedForPlaylist) {
      playList.add(playListModel.toJson());
    }
    await Hive.box('play_list').put(
      nameOfEditingPlaylist.value,
      playList,
    );
    selectForPlaylistMode.value = false;
    selectedForPlaylist.clear();
  }

  void reloadPlayList() {
    allPlaylistInDB.clear();
    final infoBox = Hive.box('play_list');
    for (var key in infoBox.keys) {
      List playList = infoBox.get(key);
      List<PlayListModel> playListModels = [];
      for (var playListJson in playList) {
        playListModels.add(PlayListModel.fromJson(playListJson));
      }
      allPlaylistInDB
          .add(AllPlayListModel(playList: playListModels, name: key));
    }
  }

  Future<String?> backupNote(List<NotesModel> notes) async {
    try {
      if (notes.isEmpty) {
        return 'No notes found';
      }

      List<String> rawPlaylistData = [];
      for (var playList in notes) {
        rawPlaylistData.add(playList.toJson());
      }
      String rawJson = jsonEncode(rawPlaylistData);
      final db = Databases(AppWriteConfig.client);

      try {
        final AuthController authController = Get.find<AuthController>();
        String id = authController.loggedInUser.value!.$id;
        if (Hive.box('cloud_notes_db').keys.isNotEmpty) {
          await db.updateDocument(
            databaseId: authController.databaseID,
            collectionId: authController.collectionIDNotes,
            documentId: id,
            data: {
              'notes': rawJson,
            },
          );
          await Hive.box('cloud_notes_db').put('all_notes', rawJson);
        } else {
          await db.createDocument(
            databaseId: authController.databaseID,
            collectionId: authController.collectionIDNotes,
            documentId: id,
            data: {
              'notes': rawJson,
            },
          );
          await Hive.box('cloud_notes_db').put('all_notes', rawJson);
        }
      } on AppwriteException catch (e) {
        return e.message;
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> backupGroups(List<CollectionInfoModel> groups) async {
    try {
      if (groups.isEmpty) {
        return 'No groups found';
      }

      List<String> rawGroupsData = [];
      for (var playList in groups) {
        rawGroupsData.add(playList.toJson());
      }
      String rawJson = jsonEncode(rawGroupsData);
      final db = Databases(AppWriteConfig.client);

      try {
        final AuthController authController = Get.find<AuthController>();
        String id = authController.loggedInUser.value!.$id;
        if (Hive.box('cloud_collections_db').keys.isNotEmpty) {
          await db.updateDocument(
            databaseId: authController.databaseID,
            collectionId: authController.collectionIDCollections,
            documentId: id,
            data: {
              'collections': rawJson,
            },
          );
          await Hive.box('cloud_collections_db')
              .put('all_collections', rawJson);
        } else {
          await db.createDocument(
            databaseId: authController.databaseID,
            collectionId: authController.collectionIDCollections,
            documentId: id,
            data: {
              'collections': rawJson,
            },
          );
          await Hive.box('cloud_collections_db')
              .put('all_collections', rawJson);
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
