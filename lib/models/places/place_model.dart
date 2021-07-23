import 'package:cambodia_geography/models/places/image_model.dart';

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
    this.commentLength,
    this.villageCode,
    this.lat,
    this.lon,
    this.body,
    this.id,
  });

  DateTime? createdAt;
  DateTime? updatedAt;
  List<ImageModel>? images;
  List<String>? comments;
  String? type;
  String? khmer;
  String? english;
  String? provinceCode;
  String? districtCode;
  String? communeCode;
  int? commentLength;
  String? villageCode;
  double? lat;
  double? lon;
  String? body;
  String? id;

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      images: List<ImageModel>.from(json["images"].map((x) => ImageModel.fromJson(x))),
      comments: List<String>.from(json["comments"].map((x) => x)),
      type: json["type"],
      khmer: json["khmer"],
      english: json["english"],
      provinceCode: json["province_code"],
      districtCode: json["district_code"],
      communeCode: json["commune_code"],
      commentLength: json["comment_length"],
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
      "comments": List<dynamic>.from(comments?.map((x) => x) ?? []),
      "type": type,
      "khmer": khmer,
      "english": english,
      "province_code": provinceCode,
      "district_code": districtCode,
      "commune_code": communeCode,
      "comment_lenght": commentLength,
      "village_code": villageCode,
      "lat": lat,
      "lon": lon,
      "body": body,
      "id": id,
    };
  }
}
