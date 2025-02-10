import 'package:al_quran_tafsir_and_audio/src/functions/decode_compressed_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class TafsirView extends StatelessWidget {
  final int ayahNumber;
  final String tafsirBookID;
  final String? surahName;
  final double? fontSize;
  final bool showAppBar;
  const TafsirView({
    super.key,
    required this.ayahNumber,
    required this.tafsirBookID,
    this.surahName,
    this.fontSize,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(surahName != null
                  ? '$surahName ( ${ayahNumber + 1} )'
                  : 'Tafsir'.tr),
            )
          : null,
      body: FutureBuilder(
        future: getTafsirText(tafsirBookID, ayahNumber),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Scrollbar(
                controller: scrollController,
                interactive: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  controller: scrollController,
                  child: (snapshot.data != null && snapshot.data!.isEmpty)
                      ? Center(
                          child: Text('No Tafsir Found'.tr),
                        )
                      : HtmlWidget(
                          snapshot.data!,
                          textStyle: TextStyle(
                            fontSize: fontSize,
                          ),
                        ),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text(
                'No Tafsir Found'.tr,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
}

Future<String> getTafsirText(String tafsirBookID, int ayahNumber) async {
  final box = Hive.box('tafsir_db');
  String compressedText = box.get('$tafsirBookID/$ayahNumber');
  return decompressStringWithGZip(compressedText);
}
