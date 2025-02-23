import 'package:al_quran_tafsir_and_audio/src/al_quran_tafsir_and_audio.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(450, 800),
    windowButtonVisibility: true,
    backgroundColor: Colors.transparent,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setMaximizable(false);
    await windowManager.setMinimizable(true);
  });

  Client client = Client();

  client
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('alqurantafsirandaudio')
      .setSelfSigned(status: true);
  await Hive.initFlutter('al_quran');
  await Hive.openBox('user_db');
  await Hive.openBox('quran_db');
  await Hive.openBox('translation_db');
  await Hive.openBox('tafsir_db');
  await Hive.openBox('play_list');
  await Hive.openBox('cloud_play_list');
  await Hive.openBox('collections_db');
  await Hive.openBox('cloud_collections_db');
  await Hive.openBox('audio_track');
  await Hive.openBox('notes_db');
  await Hive.openBox('cloud_notes_db');
  runApp(const AlQuranTafsirAndAudio());
}
