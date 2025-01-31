import 'dart:convert';

class JuzInfoModel {
  final int id;
  final int juzNumber;
  final Map<String, String> verseMapping;
  final int firstVerseId;
  final int lastVerseId;
  final int versesCount;

  JuzInfoModel({
    required this.id,
    required this.juzNumber,
    required this.verseMapping,
    required this.firstVerseId,
    required this.lastVerseId,
    required this.versesCount,
  });

  JuzInfoModel copyWith({
    int? id,
    int? juzNumber,
    Map<String, String>? verseMapping,
    int? firstVerseId,
    int? lastVerseId,
    int? versesCount,
  }) =>
      JuzInfoModel(
        id: id ?? this.id,
        juzNumber: juzNumber ?? this.juzNumber,
        verseMapping: verseMapping ?? this.verseMapping,
        firstVerseId: firstVerseId ?? this.firstVerseId,
        lastVerseId: lastVerseId ?? this.lastVerseId,
        versesCount: versesCount ?? this.versesCount,
      );

  factory JuzInfoModel.fromJson(String str) =>
      JuzInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JuzInfoModel.fromMap(Map<String, dynamic> json) => JuzInfoModel(
        id: json['id'],
        juzNumber: json['juz_number'],
        verseMapping: Map.from(json['verse_mapping'])
            .map((k, v) => MapEntry<String, String>(k, v)),
        firstVerseId: json['first_verse_id'],
        lastVerseId: json['last_verse_id'],
        versesCount: json['verses_count'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'juz_number': juzNumber,
        'verse_mapping': Map.from(verseMapping)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        'first_verse_id': firstVerseId,
        'last_verse_id': lastVerseId,
        'verses_count': versesCount,
      };
}
