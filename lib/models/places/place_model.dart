import 'package:cambodia_geography/models/places/comment_model.dart';

class PlaceModel {
  PlaceModel({
    this.createdAt,
    this.updatedAt,
    this.images,
    this.comments,
    this.type,
    this.khmer,
    this.english,
    this.provinceCode,
    this.districtCode,
    this.communeCode,
    this.villageCode,
    this.lat,
    this.lon,
    this.body,
    this.id,
  });

  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? images;
  List<CommentModel>? comments;
  String? type;
  String? khmer;
  String? english;
  String? provinceCode;
  String? districtCode;
  String? communeCode;
  String? villageCode;
  double? lat;
  double? lon;
  String? body;
  String? id;

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      images: List<String>.from(json["images"].map((x) => x)),
      comments: List<CommentModel>.from(json["comments"].map((x) => CommentModel.fromJson(x))),
      type: json["type"],
      khmer: json["khmer"],
      english: json["english"],
      provinceCode: json["province_code"],
      districtCode: json["district_code"],
      communeCode: json["commune_code"],
      villageCode: json["village_code"],
      lat: json["lat"].toDouble(),
      lon: json["lon"].toDouble(),
      body: json["body"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "images": List<dynamic>.from(images?.map((x) => x) ?? []),
      "comments": List<dynamic>.from(comments?.map((x) => x.toJson()) ?? []),
      "type": type,
      "khmer": khmer,
      "english": english,
      "province_code": provinceCode,
      "district_code": districtCode,
      "commune_code": communeCode,
      "village_code": villageCode,
      "lat": lat,
      "lon": lon,
      "body": body,
      "id": id,
    };
  }
}
