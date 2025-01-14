import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../resources/quran_com/all_recitations.dart';
import '../resources/recitation_info_model.dart';

class AudioController extends GetxController {
  static final box = Hive.box("user_db");
  RxInt currentSurahNumber = (-1).obs;
  RxInt currentReciterIndex = (0).obs;
  RxInt currentPlayListIndex = (0).obs;
  RxInt setupSelectedReciterIndex = (0).obs;
  RxBool isFullScreenMode = false.obs;
  RxInt totalAyah = (0).obs;

  RxInt currentPlayingAyah = (0).obs;
  Rx<ReciterInfoModel> currentReciterModel = ReciterInfoModel.fromJson(
    box.get(
      "default_reciter",
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
}
