import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/tabs/collection_tab/controller/collection_model.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/notes/controller/notes_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/notes/models/notes_model.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:appwrite/models.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../api/appwrite/config.dart';
import '../../screens/home/controller/home_page_controller.dart';
import '../../screens/home/controller/model/play_list_model.dart';

class AuthController extends GetxController {
  Rx<User?> loggedInUser = Rx<User?>(null);

  String databaseID = '678670ae00193586bc94';
  String collectionIDPlayList = 'all_play_list';
  String collectionIDNotes = '67a64d200021350650b6';
  String collectionIDCollections = '67a64d2e00215c5aaec0';

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  Future<User?> getUser() async {
    try {
      final user = await AppWriteConfig.account.get();
      loggedInUser.value = user;
      return user;
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
    return null;
  }

  Future<String?> login(String email, String password) async {
    try {
      await AppWriteConfig.account
          .createEmailPasswordSession(email: email, password: password);
    } on AppwriteException catch (e) {
      return e.message;
    }
    final user = await AppWriteConfig.account.get();
    loggedInUser.value = user;
    String id = user.$id;
    final AuthController authController = Get.find<AuthController>();

    // get playlist
    try {
      final response = await Databases(AppWriteConfig.client).getDocument(
        databaseId: authController.databaseID,
        collectionId: authController.collectionIDPlayList,
        documentId: id,
      );

      if (response.data['all_playlist_data'] != null) {
        await Hive.box('cloud_play_list').put(
          'all_playlist',
          response.data['all_playlist_data'],
        );
        List<String> rawPlayList =
            List<String>.from(jsonDecode(response.data['all_playlist_data']));
        for (var rawPlayList in rawPlayList) {
          final decodeSinglePlayList = AllPlayListModel.fromJson(rawPlayList);
          List<String> playList = [];
          for (var playListModel in decodeSinglePlayList.playList) {
            playList.add(playListModel.toJson());
          }
          await Hive.box('play_list').put(
            decodeSinglePlayList.name,
            playList,
          );
        }
      }

      HomePageController homePageController = Get.find<HomePageController>();
      homePageController.reloadPlayList();
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }

    // get notes
    try {
      final response = await Databases(AppWriteConfig.client).getDocument(
        databaseId: authController.databaseID,
        collectionId: authController.collectionIDNotes,
        documentId: id,
      );

      await Hive.box('cloud_notes_db').clear();
      if (response.data['notes'] != null) {
        await Hive.box('cloud_notes_db').put(
          'all_notes',
          response.data['notes'],
        );
        List<String> rawNotesList =
            List<String>.from(jsonDecode(response.data['notes']));
        List<NotesModel> notesList = [];
        for (var rawPlayNote in rawNotesList) {
          final decodeSingleNote = NotesModel.fromJson(rawPlayNote);
          notesList.add(decodeSingleNote);
        }
        await Hive.box('notes_db').clear();
        for (var note in notesList) {
          await Hive.box('notes_db').put(
            math.Random().nextInt(100000).toString(),
            note.toJson(),
          );
        }
        final NotesController notesController = Get.put(NotesController());
        notesController.onInit();
      }
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }

    // get collections
    try {
      final response = await Databases(AppWriteConfig.client).getDocument(
        databaseId: authController.databaseID,
        collectionId: authController.collectionIDCollections,
        documentId: id,
      );

      await Hive.box('cloud_collections_db').clear();
      if (response.data['collections'] != null) {
        await Hive.box('cloud_collections_db').put(
          'all_collections',
          response.data['collections'],
        );

        log(response.data['collections'],
            name: "response.data['collections'],");
        List<String> rawCollectionList =
            List<String>.from(jsonDecode(response.data['collections']));
        log(rawCollectionList.toString(), name: 'rawCollectionList,');
        List<CollectionInfoModel> collectionModelList = [];
        for (var rawCollect in rawCollectionList) {
          final decodeSingleCollection =
              CollectionInfoModel.fromJson(rawCollect);
          collectionModelList.add(decodeSingleCollection);
        }
        await Hive.box('collections_db').clear();
        for (var note in collectionModelList) {
          await Hive.box('collections_db').put(
            math.Random().nextInt(100000).toString(),
            note.toJson(),
          );
        }
        final CollectionController collectionController =
            Get.put(CollectionController());
        collectionController.onInit();
      }
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }

    return null;
  }

  Future<String?> register(String email, String password) async {
    try {
      await AppWriteConfig.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      return e.message;
    }
    return await login(email, password);
  }

  Future<void> logout() async {
    await AppWriteConfig.account.deleteSession(sessionId: 'current');
    loggedInUser.value = null;
  }
}
