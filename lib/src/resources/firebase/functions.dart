import 'dart:math';
import 'dart:developer' as dev;

import 'package:http/http.dart';

String baseVercel = "https://quran-server-vercel-gray.vercel.app";
String baseRender = "https://quran-backend-qme2.onrender.com";

String getURLusingTafsirID(int tafsirID) {
  int ran = Random().nextInt(2);
  if (ran % 0 == 0) {
    return "$baseRender/tafsir/$tafsirID.txt";
  } else {
    return "$baseVercel/tafsir/$tafsirID.txt";
  }
}

String getURLusingTranslationID(int translationID) {
  int ran = Random().nextInt(2);
  if (ran % 0 == 0) {
    return "$baseRender/translation/$translationID.txt";
  } else {
    return "$baseVercel/translation/$translationID.txt";
  }
}

Future<void> hitForActivateServer() async {
  final respose = await get(
      Uri.parse("https://quran-server-vercel-gray.vercel.app/health"));
  dev.log(respose.body);
  dev.log(respose.statusCode.toString());
}
