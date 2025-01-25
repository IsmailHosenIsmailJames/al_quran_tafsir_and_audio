import 'dart:convert';

class TrackingAudioModel {
  int surahNumber;
  Set<int> playedAyah;
  int totalPlayedDurationInSeconds;
  String lastReciterId;

  TrackingAudioModel({
    required this.surahNumber,
    required this.playedAyah,
    required this.totalPlayedDurationInSeconds,
    required this.lastReciterId,
  });

  TrackingAudioModel copyWith({
    int? surahNumber,
    Set<int>? playedAyah,
    int? totalPlayedDurationInSeconds,
    String? lastReciterId,
  }) =>
      TrackingAudioModel(
        surahNumber: surahNumber ?? this.surahNumber,
        playedAyah: playedAyah ?? this.playedAyah,
        totalPlayedDurationInSeconds:
            totalPlayedDurationInSeconds ?? this.totalPlayedDurationInSeconds,
        lastReciterId: lastReciterId ?? this.lastReciterId,
      );

  factory TrackingAudioModel.fromJson(String str) =>
      TrackingAudioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TrackingAudioModel.fromMap(Map<String, dynamic> json) =>
      TrackingAudioModel(
        surahNumber: json["surahNumber"],
        playedAyah: Set<int>.from(json["playedAyah"]),
        totalPlayedDurationInSeconds: json["totalPlayedDurationInSeconds"],
        lastReciterId: json["lastReciterID"],
      );

  Map<String, dynamic> toMap() => {
        "surahNumber": surahNumber,
        "playedAyah": playedAyah.toList(),
        "totalPlayedDurationInSeconds": totalPlayedDurationInSeconds,
        "lastReciterID": lastReciterId,
      };
}
