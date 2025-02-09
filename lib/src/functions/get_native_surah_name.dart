import '../resources/surah_native_translation/surah_name_native_translation.dart';

String getSurahNativeName(String languageKey, int surahNumber) {
  return (surahNameTransIn20Language[languageKey] ??
      surahNameTransIn20Language['en']!)[surahNumber];
}
