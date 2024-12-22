import 'package:al_quran_tafsir_and_audio/src/screens/home/home_page.dart';
import 'package:flutter/material.dart';

class AlQuranTafsirAndAudio extends StatelessWidget {
  const AlQuranTafsirAndAudio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al Quran',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
