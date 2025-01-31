import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class InfoViewOfSurah extends StatelessWidget {
  final String surahName;
  final String infoURL;
  final String languageName;
  const InfoViewOfSurah({
    super.key,
    required this.surahName,
    required this.infoURL,
    required this.languageName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          surahName,
        ),
      ),
      body: FutureBuilder(
        future: get(Uri.parse('$infoURL?language=$languageName')),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data =
                Map.from(jsonDecode(snapshot.data!.body))['chapter_info'];
            String languageName = data['language_name'];
            String shortText = data['short_text'];
            String text = data['text'];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Language Name : ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const Gap(5),
                      Text(
                        languageName.capitalizeFirst,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  Text(
                    'Summary : ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Text(shortText),
                  const Gap(15),
                  Text(
                    'Details : ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  HtmlWidget(text),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text(
                'Something went wrong, Please check your internet connection',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
}
