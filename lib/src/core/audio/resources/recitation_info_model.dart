import 'dart:convert';

class RecitationInfoModel {
  String? link;
  String? name;
  String? bitrate;
  String? style;

  RecitationInfoModel({
    this.link,
    this.name,
    this.bitrate,
    this.style,
  });

  RecitationInfoModel copyWith({
    String? link,
    String? name,
    String? bitrate,
    String? style,
  }) =>
      RecitationInfoModel(
        link: link ?? this.link,
        name: name ?? this.name,
        bitrate: bitrate ?? this.bitrate,
        style: style ?? this.style,
      );

  factory RecitationInfoModel.fromJson(String str) =>
      RecitationInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RecitationInfoModel.fromMap(Map<String, dynamic> json) =>
      RecitationInfoModel(
        link: json["link"],
        name: json["name"],
        bitrate: json["bitrate"],
        style: json["style"],
      );

  Map<String, dynamic> toMap() => {
        "link": link,
        "name": name,
        "bitrate": bitrate,
        "style": style,
      };
}
