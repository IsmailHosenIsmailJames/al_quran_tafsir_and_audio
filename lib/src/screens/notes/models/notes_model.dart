import 'dart:convert';

class NotesModel {
  final int dateTimestamp;
  final String noteDelta;
  final List<String> ayahsKey;

  NotesModel({
    required this.dateTimestamp,
    required this.noteDelta,
    required this.ayahsKey,
  });

  NotesModel copyWith({
    int? dateTimestamp,
    String? noteDelta,
    List<String>? ayahsKey,
  }) =>
      NotesModel(
        dateTimestamp: dateTimestamp ?? this.dateTimestamp,
        noteDelta: noteDelta ?? this.noteDelta,
        ayahsKey: ayahsKey ?? this.ayahsKey,
      );

  factory NotesModel.fromJson(String str) =>
      NotesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotesModel.fromMap(Map<String, dynamic> json) => NotesModel(
        dateTimestamp: json['date_timestamp'],
        noteDelta: json['note_delta'],
        ayahsKey: List<String>.from(json['ayahsKey'].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        'date_timestamp': dateTimestamp,
        'note_delta': noteDelta,
        'ayahsKey': List<dynamic>.from(ayahsKey.map((x) => x)),
      };
}
