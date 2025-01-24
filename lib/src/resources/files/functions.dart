import 'dart:math';
import 'dart:developer' as dev;

import 'package:http/http.dart';

String baseVercel = "https://quran-backend-delta.vercel.app";
String baseRender = "https://quran-backend-7hyd.onrender.com";

String getURLusingTafsirID(int tafsirID) {
  int ran = Random().nextInt(2);
  if (ran % 2 == 0) {
    return "$baseRender/tafsir/$tafsirID.txt";
  } else {
    return "$baseVercel/tafsir/$tafsirID.txt";
  }
}

String getURLusingTranslationID(int translationID) {
  int ran = Random().nextInt(2);
  if (ran % 2 == 0) {
    return "$baseRender/translation/$translationID.txt";
  } else {
    return "$baseVercel/translation/$translationID.txt";
  }
}

Future<void> hitForActivateServer() async {
  final respose = await get(Uri.parse("$baseVercel/health"));
  dev.log(respose.body);
  dev.log(respose.statusCode.toString());
}
