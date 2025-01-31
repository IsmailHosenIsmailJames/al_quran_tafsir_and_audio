import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/audio/controller/audio_controller.dart';
import '../../core/audio/resources/recitation_info_model.dart';
import 'model.dart';

TrackingAudioModel? trackingAudioModel;
AudioController audioController = Get.find();

/// Records user's progress in listening to Quran audio.
///
/// This function will be called whenever the user starts playing a new ayah.
/// It will update the total duration of the ayah and the total duration played
/// so far. If the function is called for the first time for a particular surah,
/// it will create a new entry in the database. If the function is called again
/// for the same surah, it will update the existing entry.
///
/// The data is stored in Hive under the key "audio_track" and is stored as a
/// Map with the following keys:
/// - "surahNumber": int
/// - "totalDurationInSeconds": int
/// - "totalPlayedDurationInSeconds": int
/// - "lastReciterId": String
void audioTracking() {
  int currentPlayingSurah = audioController.currentSurahNumber.value;
  ReciterInfoModel currentReciterModel =
      audioController.currentReciterModel.value;
  final box = Hive.box('audio_track');
  if (trackingAudioModel == null) {
    // try to retrieve form db
    Map? previousData = box.get(currentPlayingSurah);
    if (previousData != null) {
      trackingAudioModel =
          TrackingAudioModel.fromMap(Map<String, dynamic>.from(previousData));
      trackingAudioModel?.playedAyah
          .add(audioController.currentPlayingAyah.value);
    } else {
      trackingAudioModel = TrackingAudioModel(
        surahNumber: currentPlayingSurah,
        playedAyah: {audioController.currentPlayingAyah.value},
        totalPlayedDurationInSeconds: 0,
        lastReciterId: currentReciterModel.link,
      );
    }
  } else {
    trackingAudioModel!.playedAyah
        .add(audioController.currentPlayingAyah.value);
  }

  if (trackingAudioModel == null) {
    return;
  }

  trackingAudioModel!.surahNumber = currentPlayingSurah;

  trackingAudioModel!.totalPlayedDurationInSeconds += 1;

  box.put(currentPlayingSurah, trackingAudioModel!.toMap());
}
