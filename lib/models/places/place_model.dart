import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/app_constant.dart';
import 'package:cambodia_geography/models/image_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'place_model.g.dart';

@JsonSerializable()
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

  @JsonKey(name: 'create_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  List<ImageModel>? images;
  List<String>? comments;
  String? type;
  String? khmer;
  String? english;
  @JsonKey(name: 'province_code')
  String? provinceCode;
  @JsonKey(name: 'district_code')
  String? districtCode;
  @JsonKey(name: 'commune_code')
  String? communeCode;
  @JsonKey(name: 'comment_length')
  int? commentLength;
  @JsonKey(name: 'village_code')
  String? villageCode;
  double? lat;
  double? lon;
  String? body;
  String? id;

  void clearCommuneCode() {
    this.communeCode = null;
  }

  void clearDistrictCode() {
    this.districtCode = null;
  }

  void clearVillageCode() {
    this.villageCode = null;
  }

  PlaceModel copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ImageModel>? images,
    List<String>? comments,
    String? type,
    String? khmer,
    String? english,
    String? provinceCode,
    String? districtCode,
    String? communeCode,
    int? commentLength,
    String? villageCode,
    double? lat,
    double? lon,
    String? body,
    String? id,
  }) {
    return PlaceModel(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      comments: comments ?? this.comments,
      type: type ?? this.type,
      khmer: khmer ?? this.khmer,
      english: english ?? this.english,
      provinceCode: provinceCode ?? this.provinceCode,
      districtCode: districtCode ?? this.districtCode,
      communeCode: communeCode ?? this.communeCode,
      commentLength: commentLength ?? this.commentLength,
      villageCode: villageCode ?? this.villageCode,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      body: body ?? this.body,
      id: id ?? this.id,
    );
  }

  List<String> paramNames() {
    return [
      "type",
      "khmer",
      "english",
      "province_code",
      "district_code",
      "commune_code",
      "village_code",
      "lat",
      "lon",
      "body",
    ];
  }

  Map<String, dynamic> sliceParams(Map<String, dynamic> values, List<String> names) {
    Map<String, dynamic> result = {};
    names.forEach((element) {
      result[element] = values[element];
    });
    return result;
  }

  factory PlaceModel.empty() {
    return PlaceModel(
      type: AppContant.placeType.first,
      provinceCode: CambodiaGeography.instance.tbProvinces.first.code,
      khmer: "",
      english: "",
      body: "",
    );
  }

  factory PlaceModel.fromJson(Map<String, dynamic> json) => _$PlaceModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);
}
