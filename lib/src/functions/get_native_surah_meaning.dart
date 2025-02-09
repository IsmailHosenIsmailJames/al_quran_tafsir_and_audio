import 'package:al_quran_tafsir_and_audio/src/resources/surah_native_translation/surah_meaning_native_translation.dart';

String getSurahNativeMeaning(String languageKey, int surahNumber) {
  return (surahMeaningTransIn20Language[languageKey] ??
      surahMeaningTransIn20Language['en']!)[surahNumber];
}
