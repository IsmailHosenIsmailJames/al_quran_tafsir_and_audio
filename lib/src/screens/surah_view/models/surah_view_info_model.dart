import 'dart:convert';

class SurahViewInfoModel {
  final int surahNumber;
  final int start;
  final int end;
  final int ayahCount;
  final String surahNameArabic;
  final String surahNameSimple;
  final String revelationPlace;
  final bool isStartWithBismillah;

  SurahViewInfoModel({
    required this.surahNumber,
    required this.start,
    required this.end,
    required this.ayahCount,
    required this.surahNameArabic,
    required this.surahNameSimple,
    required this.revelationPlace,
    required this.isStartWithBismillah,
  });

  SurahViewInfoModel copyWith({
    int? surahNumber,
    int? start,
    int? end,
    int? ayahCount,
    String? surahNameArabic,
    String? surahNameSimple,
    String? revelationPlace,
    bool? isStartWithBismillah,
  }) =>
      SurahViewInfoModel(
        surahNumber: surahNumber ?? this.surahNumber,
        start: start ?? this.start,
        end: end ?? this.end,
        ayahCount: ayahCount ?? this.ayahCount,
        surahNameArabic: surahNameArabic ?? this.surahNameArabic,
        surahNameSimple: surahNameSimple ?? this.surahNameSimple,
        revelationPlace: revelationPlace ?? this.revelationPlace,
        isStartWithBismillah: isStartWithBismillah ?? this.isStartWithBismillah,
      );

  factory SurahViewInfoModel.fromJson(String str) =>
      SurahViewInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SurahViewInfoModel.fromMap(Map<String, dynamic> json) =>
      SurahViewInfoModel(
        surahNumber: json["surahNumber"],
        start: json["start"],
        end: json["end"],
        ayahCount: json["ayahCount"],
        surahNameArabic: json["surahNameArabic"],
        surahNameSimple: json["surahNameSimple"],
        revelationPlace: json["revelationPlace"],
        isStartWithBismillah: json["isStartWithBismillah"],
      );

  Map<String, dynamic> toMap() => {
        "surahNumber": surahNumber,
        "start": start,
        "end": end,
        "ayahCount": ayahCount,
        "surahNameArabic": surahNameArabic,
        "surahNameSimple": surahNameSimple,
        "revelationPlace": revelationPlace,
        "isStartWithBismillah": isStartWithBismillah,
      };
}
