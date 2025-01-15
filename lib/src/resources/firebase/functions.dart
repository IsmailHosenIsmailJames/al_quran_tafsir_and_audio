import 'package:al_quran_tafsir_and_audio/src/resources/firebase/qurans_resources_link.dart';

String getURLusingTafsirID(int tafsirID, int ranIndex) {
  String? url = tafsirs[ranIndex][tafsirID];
  if (url == null) {
    tafsirs[ranIndex].forEach((key, value) {
      if (key == tafsirID) {
        url = value;
      }
    });
  }
  return url!;
}

String getURLusingTranslationID(int translationID, int ranIndex) {
  String? url = translation[ranIndex][translationID];
  if (url == null) {
    translation[ranIndex].forEach((key, value) {
      if (key == translationID) {
        url = value;
      }
    });
  }
  return url!;
}
