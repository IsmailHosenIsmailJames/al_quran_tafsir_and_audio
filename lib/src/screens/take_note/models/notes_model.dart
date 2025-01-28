import 'dart:convert';

class NotesModel {
  final int dateTimestamp;
  final String noteDelta;
  final int surahNumber;
  final int ayahNumber;

  NotesModel({
    required this.dateTimestamp,
    required this.noteDelta,
    required this.surahNumber,
    required this.ayahNumber,
  });

  NotesModel copyWith({
    int? dateTimestamp,
    String? noteDelta,
    int? surahNumber,
    int? ayahNumber,
  }) =>
      NotesModel(
        dateTimestamp: dateTimestamp ?? this.dateTimestamp,
        noteDelta: noteDelta ?? this.noteDelta,
        surahNumber: surahNumber ?? this.surahNumber,
        ayahNumber: ayahNumber ?? this.ayahNumber,
      );

  factory NotesModel.fromJson(String str) =>
      NotesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotesModel.fromMap(Map<String, dynamic> json) => NotesModel(
        dateTimestamp: json["date_timestamp"],
        noteDelta: json["note_delta"],
        surahNumber: json["surah_number"],
        ayahNumber: json["ayah_number"],
      );

  Map<String, dynamic> toMap() => {
        "date_timestamp": dateTimestamp,
        "note_delta": noteDelta,
        "surah_number": surahNumber,
        "ayah_number": ayahNumber,
      };
}
