import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:al_quran_tafsir_and_audio/src/resources/firebase/functions.dart';
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

  InfoController infoController = Get.find();

  @override
  void initState() {
    downloadData();
    super.initState();
  }

  Future<void> downloadData() async {
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
      final response = await get(Uri.parse(listOfQuranScript[i]));
      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(jsonDecode(response.body));
        List<Map> verses = List<Map>.from(data["verses"]);
        for (int i = 0; i < verses.length; i++) {
          final id = verses[i]["id"];
          String textKey = "text_$lastPath";
          quranDB.put(
            "lastPath/$id",
            verses[i][textKey],
          );
        }
      }
      setState(() {
        progressValue += 10;
      });
    }

    // skip chapter info. Because it support multi language

    final tafsirDB = Hive.box("tafsir_db");
    int ran = math.Random().nextInt(4);

    String? url = getURLusingTafsirID(infoController.tafsirBookID.value, ran);
    log(url.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Downloading...",
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
          ],
        ),
      ),
    );
  }
}
