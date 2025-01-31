import 'dart:convert';

class CollectionInfoModel {
  String id;
  bool isPublicResources;
  String name;
  String? description;
  List<String>? ayahs;
  String? createdBy;
  String? createdAt;
  int? peopleAdded;

  CollectionInfoModel({
    required this.id,
    required this.isPublicResources,
    required this.name,
    this.description,
    this.ayahs,
    this.createdBy,
    this.createdAt,
    this.peopleAdded,
  });

  CollectionInfoModel copyWith({
    String? id,
    bool? isPublicResources,
    String? name,
    String? description,
    List<String>? ayahs,
    String? createdBy,
    String? createdAt,
    int? peopleAdded,
  }) =>
      CollectionInfoModel(
        id: id ?? this.id,
        isPublicResources: isPublicResources ?? this.isPublicResources,
        name: name ?? this.name,
        description: description ?? this.description,
        ayahs: ayahs ?? this.ayahs,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        peopleAdded: peopleAdded ?? this.peopleAdded,
      );

  factory CollectionInfoModel.fromJson(String str) =>
      CollectionInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CollectionInfoModel.fromMap(Map<String, dynamic> json) =>
      CollectionInfoModel(
        id: json['id'],
        isPublicResources: json['is_public_resources'],
        name: json['name'],
        description: json['description'],
        ayahs: List<String>.from(json['ayahs'].map((x) => x)),
        createdBy: json['created_by'],
        createdAt: json['created_at'],
        peopleAdded: json['people_added'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'is_public_resources': isPublicResources,
        'name': name,
        'description': description,
        'ayahs':
            ayahs == null ? null : List<dynamic>.from(ayahs!.map((x) => x)),
        'created_by': createdBy,
        'created_at': createdAt,
        'people_added': peopleAdded,
      };
}
