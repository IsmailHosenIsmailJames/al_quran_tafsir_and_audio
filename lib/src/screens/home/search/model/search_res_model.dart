import 'dart:convert';

class SearchResModel {
  String? query;
  int? totalResults;
  int? currentPage;
  int? totalPages;
  List<Result>? results;

  SearchResModel({
    this.query,
    this.totalResults,
    this.currentPage,
    this.totalPages,
    this.results,
  });

  SearchResModel copyWith({
    String? query,
    int? totalResults,
    int? currentPage,
    int? totalPages,
    List<Result>? results,
  }) =>
      SearchResModel(
        query: query ?? this.query,
        totalResults: totalResults ?? this.totalResults,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        results: results ?? this.results,
      );

  factory SearchResModel.fromJson(String str) =>
      SearchResModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchResModel.fromMap(Map<String, dynamic> json) => SearchResModel(
        query: json['query'],
        totalResults: json['total_results'],
        currentPage: json['current_page'],
        totalPages: json['total_pages'],
        results: json['results'] == null
            ? []
            : List<Result>.from(json['results']!.map((x) => Result.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'query': query,
        'total_results': totalResults,
        'current_page': currentPage,
        'total_pages': totalPages,
        'results': results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toMap())),
      };
}

class Result {
  String? verseKey;
  int? verseId;
  String? text;
  dynamic highlighted;
  List<Word>? words;
  List<Translation>? translations;

  Result({
    this.verseKey,
    this.verseId,
    this.text,
    this.highlighted,
    this.words,
    this.translations,
  });

  Result copyWith({
    String? verseKey,
    int? verseId,
    String? text,
    dynamic highlighted,
    List<Word>? words,
    List<Translation>? translations,
  }) =>
      Result(
        verseKey: verseKey ?? this.verseKey,
        verseId: verseId ?? this.verseId,
        text: text ?? this.text,
        highlighted: highlighted ?? this.highlighted,
        words: words ?? this.words,
        translations: translations ?? this.translations,
      );

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        verseKey: json['verse_key'],
        verseId: json['verse_id'],
        text: json['text'],
        highlighted: json['highlighted'],
        words: json['words'] == null
            ? []
            : List<Word>.from(json['words']!.map((x) => Word.fromMap(x))),
        translations: json['translations'] == null
            ? []
            : List<Translation>.from(
                json['translations']!.map((x) => Translation.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'verse_key': verseKey,
        'verse_id': verseId,
        'text': text,
        'highlighted': highlighted,
        'words': words == null
            ? []
            : List<dynamic>.from(words!.map((x) => x.toMap())),
        'translations': translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x.toMap())),
      };
}

class Translation {
  String? text;
  int? resourceId;
  String? name;
  String? languageName;

  Translation({
    this.text,
    this.resourceId,
    this.name,
    this.languageName,
  });

  Translation copyWith({
    String? text,
    int? resourceId,
    String? name,
    String? languageName,
  }) =>
      Translation(
        text: text ?? this.text,
        resourceId: resourceId ?? this.resourceId,
        name: name ?? this.name,
        languageName: languageName ?? this.languageName,
      );

  factory Translation.fromJson(String str) =>
      Translation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Translation.fromMap(Map<String, dynamic> json) => Translation(
        text: json['text'],
        resourceId: json['resource_id'],
        name: json['name'],
        languageName: json['language_name'],
      );

  Map<String, dynamic> toMap() => {
        'text': text,
        'resource_id': resourceId,
        'name': name,
        'language_name': languageName,
      };
}

class Word {
  String? charType;
  String? text;

  Word({
    this.charType,
    this.text,
  });

  Word copyWith({
    String? charType,
    String? text,
  }) =>
      Word(
        charType: charType ?? this.charType,
        text: text ?? this.text,
      );

  factory Word.fromJson(String str) => Word.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Word.fromMap(Map<String, dynamic> json) => Word(
        charType: json['char_type'],
        text: json['text'],
      );

  Map<String, dynamic> toMap() => {
        'char_type': charType,
        'text': text,
      };
}
