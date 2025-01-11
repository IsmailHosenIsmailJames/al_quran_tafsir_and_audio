import 'package:al_quran_tafsir_and_audio/src/functions/decode_compressed_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hive/hive.dart';

class TafsirView extends StatelessWidget {
  final int ayahNumber;
  final String tafsirBookID;
  final String? surahName;
  final double? fontSize;
  const TafsirView({
    super.key,
    required this.ayahNumber,
    required this.tafsirBookID,
    this.surahName,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title:
            Text(surahName != null ? "$surahName ( $ayahNumber )" : "Tafsir"),
      ),
      body: FutureBuilder(
        future: getTafsirText(tafsirBookID, ayahNumber),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Scrollbar(
                controller: scrollController,
                interactive: true,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(8),
                  controller: scrollController,
                  child: HtmlWidget(
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
            return const Center(
              child: Text(
                "No Tafsir Found",
                style: TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
}

Future<String> getTafsirText(String tafsirBookID, int ayahNumber) async {
  final box = Hive.box("tafsir_db");
  String compressedText = box.get("$tafsirBookID/$ayahNumber");
  return decompressStringWithGZip2(compressedText);
}
