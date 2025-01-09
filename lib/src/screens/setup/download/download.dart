import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:al_quran_tafsir_and_audio/src/core/audio/resources/recitation_info_model.dart';
import 'package:al_quran_tafsir_and_audio/src/functions/decode_compressed_string.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/firebase/functions.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/home_page.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/setup/info_controller/info_controller_getx.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

class DownloadData extends StatefulWidget {
  final Map<String, dynamic> selection;
  const DownloadData({super.key, required this.selection});

  @override
  State<DownloadData> createState() => _DownloadDataState();
}

class _DownloadDataState extends State<DownloadData> {
  double progressValue = 0.0;
  String processState = "Downloading...";
  String errorText = "";

  InfoController infoController = Get.find();

  @override
  void initState() {
    infoController.translationLanguage.value =
        widget.selection["translation_language"];
    infoController.bookIDTranslation.value =
        widget.selection["translation_book_ID"];
    infoController.tafsirLanguage.value = widget.selection["tafsir_language"];
    infoController.tafsirBookID.value = widget.selection["tafsir_book_ID"];
    infoController.selectedReciter.value =
        RecitationInfoModel.fromJson(widget.selection["selected_recitation"]);
    downloadData();
    super.initState();
  }

  Future<void> downloadData() async {
    setState(() {
      processState = "Getting Quran...";
    });
    final quranDB = Hive.box("quran_db");
    List<String> listOfQuranScript = [
      "https://api.quran.com/api/v4/quran/verses/indopak",
      "https://api.quran.com/api/v4/quran/verses/uthmani_tajweed",
      "https://api.quran.com/api/v4/quran/verses/uthmani",
      "https://api.quran.com/api/v4/quran/verses/uthmani_simple",
      "https://api.quran.com/api/v4/quran/verses/imlaei",
    ];
    for (int i = 0; i < listOfQuranScript.length; i++) {
      String lastPath = listOfQuranScript[i].split("/").last;
      String textKey = "text_$lastPath";
      if (quranDB.keys.contains("$lastPath/1")) {
        log("Already exits $lastPath/1");
        setState(() {
          progressValue += 0.1;
        });
      } else {
        log("Downloading : $lastPath/1");
        final response = await get(Uri.parse(listOfQuranScript[i]));
        if (response.statusCode == 200) {
          Map<String, dynamic> data =
              Map<String, dynamic>.from(jsonDecode(response.body));
          List<Map> verses = List<Map>.from(data["verses"]);
          for (int i = 0; i < verses.length; i++) {
            final verseId = verses[i]["id"];
            await quranDB.put(
              "$lastPath/$verseId",
              verses[i][textKey],
            );
          }
        }
        setState(() {
          progressValue += 0.1;
        });
      }
    }

    // skip chapter info. Because it support multi language

    // download translation
    final translationDB = Hive.box("translation_db");
    int ran = math.Random().nextInt(4);
    String translationBookID = infoController.bookIDTranslation.value;
    if (translationDB.keys.contains("$translationBookID/1")) {
      setState(() {
        progressValue += 0.2;
      });
      log("Already exits translationBookID");
    } else {
      String? url = getURLusingTranslationID(translationBookID, ran);
      if (url != null) {
        final response =
            await get(Uri.parse(url), headers: {'Content-type': 'text/plain'});
        if (response.statusCode == 200) {
          String text = response.body.substring(1, response.body.length - 1);
          String decodedText = decompressStringWithGZip2(text);
          List<String> decodedJson = List<String>.from(jsonDecode(decodedText));
          for (int i = 0; i < decodedJson.length; i++) {
            await translationDB.put("$translationBookID/$i", decodedJson[i]);
          }
          setState(() {
            progressValue += 0.2;
          });
        } else {
          log("Failed to download translation");
          setState(() {
            errorText = "Failed to download translation";
          });
          return;
        }
      } else {
        log("Translation book not found");
        setState(() {
          errorText = "Translation book not found";
        });
        return;
      }
    }

    // get tafsir
    final tafsirDB = Hive.box("tafsir_db");

    String? url = getURLusingTafsirID(infoController.tafsirBookID.value, ran);
    if (!tafsirDB.keys.contains("${infoController.tafsirBookID.value}/1")) {
      if (url != null) {
        final response = await get(Uri.parse(url));
        if (response.statusCode == 200) {
          String text = response.body;
          String decodedText = decompressStringWithGZip2(text);
          List<String> decodedJson = jsonDecode(decodedText);
          for (int i = 0; i < decodedJson.length; i++) {
            await tafsirDB.put(
                "${infoController.tafsirBookID.value}/$i", decodedJson[i]);
          }
        } else {
          log("Failed to download tafsir");
          setState(() {
            errorText = "Failed to download tafsir";
          });
          return;
        }
      }
    } else {
      setState(() {
        errorText = "Tafsir book not found";
      });
      return;
    }
    setState(() {
      progressValue = 1.0;
      processState = "Download Completed";
    });
    await Future.delayed(const Duration(seconds: 1));
    Get.offAll(
      () => HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              processState,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(10),
            CircularProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
            ),
            const SizedBox(
              height: 10,
            ),
            Text("Progress : ${(progressValue * 100).toInt()}%"),
            Text(
              errorText,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
