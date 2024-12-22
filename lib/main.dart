import 'package:al_quran_tafsir_and_audio/src/al_quran_tafsir_and_audio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const AlQuranTafsirAndAudio());
}
