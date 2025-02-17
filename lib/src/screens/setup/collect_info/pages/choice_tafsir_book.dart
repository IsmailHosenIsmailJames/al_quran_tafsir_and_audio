import 'dart:convert';

import 'package:al_quran_tafsir_and_audio/src/functions/decode_compressed_string.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/api_response/some_api_response.dart';
import 'package:al_quran_tafsir_and_audio/src/resources/files/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:toastification/toastification.dart';

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
          'Tafsir Books of Quran'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          if (widget.showDownloadOnAppbar == true)
            downloading
                ? const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: CircularProgressIndicator(),
                  )
                : TextButton.icon(
                    onPressed: () async {
                      if (infoController.tafsirBookIndex.value != -1) {
                        String tafsirBookID = infoController.tafsirBookID.value;
                        debugPrint(tafsirBookID);
                        // return;
                        final infoBox = Hive.box('user_db');
                        if (tafsirBookID ==
                            infoBox.get('selection_info')['tafsir_book_ID']) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Wrong Selection'),
                                content: const Text(
                                    "Your selection can't matched with the previous selection."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }

                        await downloadData(infoBox, tafsirBookID, context);
                      }
                    },
                    icon: const Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    label: const Text(
                      'Done',
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
                padding: const EdgeInsets.only(left: 10, right: 10, top: 7),
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
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            books[index][1],
                            style: const TextStyle(fontSize: 16),
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
            ),
          );
        },
      ),
    );
  }

  void showNoInternetConnectionWidget(
      Box<dynamic> infoBox, String tafsirBookID, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: Text(
            'No internet connection!'.tr,
            style: const TextStyle(color: Colors.red),
          ),
          content: Text(
              'We need internet connection to download some required documents.'
                  .tr),
          actions: [
            TextButton.icon(
              onPressed: () {
                SystemNavigator.pop();
              },
              label: Text('Quit'.tr),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                downloadData(infoBox, tafsirBookID, context);
              },
              label: Text('Retry'.tr),
              icon: const Icon(Icons.repeat),
            ),
          ],
        );
      },
    );
  }

  Future<void> downloadData(
      Box<dynamic> infoBox, String tafsirBookID, BuildContext context) async {
    if (!(await InternetConnection().hasInternetAccess)) {
      showNoInternetConnectionWidget(infoBox, tafsirBookID, context);
      return;
    }
    setState(() {
      downloading = true;
    });

    String url = getURLusingTafsirID(
      int.parse(infoController.tafsirBookID.value.trim()),
    );

    final tafsirDB = Hive.box('tafsir_db');

    if (!tafsirDB.keys.contains('${infoController.tafsirBookID.value}/1')) {
      final response =
          await get(Uri.parse(url), headers: {'Content-type': 'text/plain'});
      if (response.statusCode == 200) {
        String text = response.body;

        String decodedText = decompressServerDataWithBZip2(text);

        List<String> decodedJson = List<String>.from(jsonDecode(decodedText));
        for (int i = 0; i < decodedJson.length; i++) {
          await tafsirDB.put('${infoController.tafsirBookID.value}/$i',
              compressStringWithGZip(decodedJson[i]));
        }
        final info = infoBox.get('selection_info', defaultValue: false);
        info['tafsir_book_ID'] = tafsirBookID;
        info['tafsir_language'] = infoController.tafsirLanguage.value;
        infoBox.put('selection_info', info);

        Get.back();
        toastification.show(
          context: context,
          title: const Text(
            'Successful',
          ),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 2),
        );
      }
    }
  }
}
