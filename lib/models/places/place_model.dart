import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/app_constant.dart';
import 'package:cambodia_geography/helpers/app_helper.dart';
import 'package:cambodia_geography/models/base_model.dart';
import 'package:cambodia_geography/models/image_model.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:json_annotation/json_annotation.dart';

import 'bookmark_model.dart';
part 'place_model.g.dart';

@JsonSerializable()
class PlaceModel extends BaseModel {
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
    this.bookmark,
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
  BookmarkModel? bookmark;

  String? page;
  void setPage(String? value) => this.page = value;

  void clearCommuneCode() {
    this.communeCode = null;
  }

  void clearDistrictCode() {
    this.districtCode = null;
  }

  void clearVillageCode() {
    this.villageCode = null;
  }

  PlaceType? placeType() {
    switch (this.type) {
      case "place":
        return PlaceType.place;
      case "restaurant":
        return PlaceType.restaurant;
      case "province":
        return PlaceType.province;
      case "geo":
        return PlaceType.geo;
      default:
    }
  }

  LatLng? latLng() {
    if (AppHelper.isLatLngValdated(this.lat, this.lon)) {
      return LatLng(this.lat!, this.lon!);
    }
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

  @override
  String? get en => this.english;

  @override
  String? get km => this.khmer;
}
