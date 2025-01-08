import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:al_quran_tafsir_and_audio/src/functions/common_functions.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/firebase/functions.dart';
import 'package:al_quran_tafsir_and_audio/src/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../info_controller/info_controller_getx.dart';

class ChoiceTafsirBook extends StatefulWidget {
  final bool? showDownloadOnAppbar;
  const ChoiceTafsirBook({super.key, this.showDownloadOnAppbar});

  @override
  State<ChoiceTafsirBook> createState() => _ChoiceTafsirBookState();
}

class _ChoiceTafsirBookState extends State<ChoiceTafsirBook> {
  final infoController = Get.put(InfoController());
  List<List<String>> books = [];
  void getBooksAsLanguage() {
    for (int i = 0; i < allTafsir.length; i++) {
      Map<String, dynamic> book = allTafsir[i];
      if (book['language_name'].toString().toLowerCase() ==
          infoController.tafsirLanguage.value.toLowerCase()) {
        String author = book['author_name'];
        String bookName = book['name'];
        String id = book['id'].toString();
        books.add([author, bookName, id]);
      }
    }
  }

  @override
  void initState() {
    getBooksAsLanguage();
    super.initState();
  }

  bool downloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tafsir Books of Quran".tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          if (widget.showDownloadOnAppbar == true)
            downloading
                ? const CircularProgressIndicator()
                : TextButton.icon(
                    onPressed: () async {
                      if (infoController.tafsirBookIndex.value != -1) {
                        String tafsirBookID = infoController.tafsirBookID.value;
                        debugPrint(tafsirBookID);
                        // return;
                        final dataBox = Hive.box("data");
                        final infoBox = Hive.box("user_db");
                        if (tafsirBookID ==
                            infoBox.get("info")['tafsir_book_ID']) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Wrong Selection"),
                                content: const Text(
                                    "Your selection can't matched with the previous selection."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }

                        dataBox.put("tafsir", false);
                        setState(() {
                          downloading = true;
                        });
                        int ran = Random().nextInt(4);

                        String? url = getURLusingTafsirID(
                            infoController.tafsirBookID.value, ran);
                        if (url == null) {
                          dev.log("url is null");
                          return;
                        }

                        var headers = {"Accept": "application/json"};

                        var response =
                            await http.get(Uri.parse(url), headers: headers);
                        final tafsirBox = await Hive.openBox("tafsir");

                        if (response.statusCode == 200) {
                          final tafsir = json.decode(response.body);
                          for (int i = 0; i < 6236; i++) {
                            String? ayah = tafsir['$i'];
                            if (ayah != null) {
                              tafsirBox.put(
                                "$tafsirBookID/$i",
                                tafsir["$i"],
                              );
                            }
                          }
                          final info = infoBox.get("info", defaultValue: false);
                          info['tafsir_book_ID'] = tafsirBookID;
                          info['tafsir_language'] =
                              infoController.tafsirLanguage.value;
                          infoBox.put("info", info);
                          dataBox.put("tafsir", true);
                          infoBox.put(
                              'tafsir', infoController.tafsirBookID.value);

                          Get.offAll(() => const HomePage());
                          showToastedMessage("Successful");
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    label: const Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                  ),
        ],
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 100, top: 10, left: 3, right: 3),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 5, top: 5),
                backgroundColor: Colors.green.shade400.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              onPressed: () {
                int value = index;
                infoController.tafsirBookIndex.value = value;
                infoController.tafsirBookID.value = books[value][2];
              },
              child: Obx(
                () => Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          books[index][1],
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          books[index][0],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (infoController.tafsirBookIndex.value == index)
                      const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
