import 'package:al_quran_tafsir_and_audio/src/resources/firebase/qurans_resources_link.dart';

String? getURLusingTafsirID(String tafsirID, int ranIndex) {
  return tafsirs[ranIndex][tafsirID];
}

String? getURLusingTranslationID(String translationID, int ranIndex) {
  return translation[ranIndex][translationID];
}
