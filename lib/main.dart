import 'package:al_quran_tafsir_and_audio/src/al_quran_tafsir_and_audio.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client();
  client
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('albayanquran')
      .setSelfSigned(status: true);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Quran Audio',
    androidNotificationOngoing: true,
  );
  await Hive.initFlutter("al_quran");
  await Hive.openBox("user_db");
  await Hive.openBox("quran_db");
  await Hive.openBox("translation_db");
  await Hive.openBox("tafsir_db");
  await Hive.openBox("play_list");
  await Hive.openBox("cloud_play_list");
  await Hive.openBox("collections_db");
  runApp(AlQuranTafsirAndAudio());
}
