import 'dart:convert';
import 'dart:developer';

import 'package:al_quran_tafsir_and_audio/src/core/audio/controller/audio_controller.dart';
import 'package:al_quran_tafsir_and_audio/src/core/audio/resources/quran_com/all_recitations.dart';
import 'package:al_quran_tafsir_and_audio/src/core/audio/resources/recitation_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../functions/audio_tracking/audio_tracting.dart';

class ManageQuranAudio {
  static AudioPlayer audioPlayer = AudioPlayer();
  static AudioController audioController = Get.put(AudioController());

  /// Plays a single ayah audio using the specified ayah and surah numbers.
  ///
  /// This function stops any currently playing audio, constructs the audio URL
  /// for the specified ayah and surah, and then plays the ayah audio using the
  /// audio player. If a reciter is not provided, it defaults to the currently
  /// selected recitation model. Optionally, a media item can be provided to
  /// set additional metadata for the audio.
  ///
  /// [ayahNumber] - The verse number within the surah to play.
  /// [surahNumber] - The chapter number in the Quran.
  /// [reciter] - (Optional) A specific reciter's information; defaults to the current recitation model if not provided.
  /// [mediaItem] - (Optional) A media item to set as the tag for the audio.
  static Future<void> startListening() async {
    log('Listening to audio stream');
    audioPlayer.durationStream.listen((event) {
      if (event != null) {
        int sec = event.inSeconds;
        if (sec != audioController.totalDuration.value.inSeconds) {
          audioController.totalDuration.value = event;
        }
      }
    });

    audioPlayer.positionStream.listen((event) {
      int sec = event.inSeconds;
      if (sec != audioController.progress.value.inSeconds) {
        audioController.progress.value = event;
        audioController.currentReciterModel;

        audioTracking();
      }
    });

    audioPlayer.speedStream.listen((event) {
      if (audioController.speed.value != event) {
        audioController.speed.value = event;
      }
    });

    audioPlayer.bufferedPositionStream.listen((event) {
      int sec = event.inSeconds;
      if (sec != audioController.bufferPosition.value.inSeconds) {
        audioController.bufferPosition.value = event;
      }
    });

    audioPlayer.playerStateStream.listen((event) {
      audioController.isPlaying.value = event.playing;
      audioController.isPlayingCompleted.value =
          event.processingState == ProcessingState.completed;

      if (event.processingState == ProcessingState.loading) {
        audioController.isLoading.value = true;
      } else {
        audioController.isLoading.value = false;
      }
    });

    audioPlayer.playbackEventStream.listen((event) {
      if (event.currentIndex != null) {
        audioController.currentPlayingAyah.value = event.currentIndex!;
      }
      audioController.isReadyToControl.value = true;
      audioController.isPlayingCompleted.value =
          event.processingState == ProcessingState.completed;
    });

    audioController.isStreamRegistered.value = true;
  }

  static Future<void> playProvidedPlayList(
      {required List<LockCachingAudioSource> playList,
      int? initialIndex}) async {
    if (audioController.isStreamRegistered.value == false) {
      await startListening();
    }
    await audioPlayer.stop();
    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: playList,
      ),
      initialIndex: initialIndex,
      initialPosition: Duration.zero,
    );
    await audioPlayer.play();
  }

  static Future<void> playMultipleAyahAsPlayList(
      {required int surahNumber,
      ReciterInfoModel? reciter,
      int? startOn,
      bool playInstantly = true}) async {
    if (audioController.isStreamRegistered.value == false) {
      await startListening();
    }
    await audioPlayer.stop();
    reciter ??= findRecitationModel();
    List<LockCachingAudioSource> audioSources = [];
    int ayahNumber = ayahCount[surahNumber + 1];
    for (var i = 0; i < ayahNumber; i++) {
      audioSources.add(
        LockCachingAudioSource(
            Uri.parse(
              makeAudioUrl(
                reciter,
                surahIDFromNumber(
                    surahNumber: surahNumber + 1, ayahNumber: i + 1),
              ),
            ),
            tag: MediaItem(
              id: '${reciter.name}$i',
              title: reciter.name,
            )),
      );
    }
    if (!(await InternetConnection().hasInternetAccess)) {
      if (await Hive.box('user_db').get('dontShowAgain', defaultValue: false) ==
          false) {
        showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Text(
                'No internet connection!'.tr,
                style: const TextStyle(color: Colors.red),
              ),
              content: Text(
                  'Internet connection is required if you play this audio for the first time.'
                      .tr),
              actions: [
                TextButton(
                    onPressed: () async {
                      await Hive.box('user_db').put('dontShowAgain', true);
                      Navigator.pop(context);
                    },
                    child: Text('Don\'t show again'.tr)),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: Text('Okay'.tr),
                ),
              ],
            );
          },
        );
      }
    }
    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: audioSources,
      ),
      initialIndex: startOn,
      initialPosition: Duration.zero,
    );

    if (playInstantly) await audioPlayer.play();
  }

  /// Generates a URL pointing to a specific ayah's audio on everyayah.com.
  ///
  /// The URL is constructed by concatenating the base API URL with the
  /// subfolder of the currently selected reciter and the ayah number. The
  /// ayah number is zero-padded with three digits. For example, if the
  /// currently selected reciter has subfolder "Abdul_Basit_Murattal_64kbps"
  /// and the ayah number is 1, the generated URL will be:
  ///
  /// https://everyayah.com/data/Abdul_Basit_Murattal_64kbps/001.mp3
  static String makeAudioUrl(ReciterInfoModel reciter, String surahID) {
    return '${reciter.link}/$surahID.mp3';
  }

  /// Retrieves the currently selected reciter from the 'info' box in hive.
  ///
  /// The currently selected reciter is stored as a JSON string in the
  /// 'reciter' key of the 'info' box in hive. When this function is called,
  /// it reads the JSON string from that key and parses it into a
  /// [ReciterInfoModel] using the [ReciterInfoModel.fromJson] method.
  /// The resulting [ReciterInfoModel] is then returned.
  static ReciterInfoModel findRecitationModel() {
    final jsonReciter = Hive.box('user_db').get(
      'default_reciter',
      defaultValue: jsonEncode(
        recitationsListOfQuranCom[0],
      ),
    );
    return ReciterInfoModel.fromJson(jsonReciter);
  }

  /// Returns a [MediaItem] with the given [surahID] and [reciter].
  ///
  /// The [MediaItem] will have:
  /// - [id] and [title] set to [surahID].
  /// - [displayTitle] set to [surahID].
  /// - [album] set to [reciter]'s name.
  /// - [artist] set to [reciter]'s subfolder.
  /// - [artUri] set to the given [artUri] if not null, or null if null.
  static MediaItem findMediaItem(
      {required String surahID,
      required ReciterInfoModel reciter,
      Uri? artUri}) {
    return MediaItem(
      id: surahID,
      title: surahID,
      displayTitle: surahID,
      album: reciter.name,
      artUri: artUri,
    );
  }

  /// Generates a formatted ayah ID string by combining the surah number
  /// and ayah number. Both numbers are zero-padded to three digits.
  ///
  /// [ayahNumber] - The verse number within the surah.
  /// [surahNumber] - The chapter number in the Quran.
  ///
  /// Returns a string representation of the ayah ID in the format 'SSSAAA'
  /// where 'SSS' is the zero-padded surah number and 'AAA' is the zero-padded ayah number.
  static String surahIDFromNumber({required int surahNumber, int? ayahNumber}) {
    return "${surahNumber.toString().padLeft(3, '0')}${ayahNumber.toString().padLeft(3, '0')}";
  }
}
