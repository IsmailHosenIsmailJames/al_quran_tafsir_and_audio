import 'package:al_quran_tafsir_and_audio/src/resources/firebase/qurans_resources_link.dart';

String getURLusingTafsirID(String tafsirID, int ranIndex) {
  String? url = tafsirs[ranIndex][tafsirID];
  if (url == null) {
    tafsirs[ranIndex].forEach((key, value) {
      if (key == tafsirID || key.contains(tafsirID)) {
        url = value;
      }
    });
  }
  return url!;
}

String getURLusingTranslationID(String translationID, int ranIndex) {
  String? url = translation[ranIndex][translationID];
  if (url == null) {
    translation[ranIndex].forEach((key, value) {
      if (key == translationID || key.contains(translationID)) {
        url = value;
      }
    });
  }
  return url!;
}
