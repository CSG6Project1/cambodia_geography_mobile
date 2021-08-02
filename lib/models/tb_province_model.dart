import 'package:json_annotation/json_annotation.dart';
part 'tb_province_model.g.dart';

@JsonSerializable()
class TbProvinceModel {
  TbProvinceModel({
    this.id,
    this.code,
    this.image,
    this.khmer,
    this.english,
    this.krong,
    this.srok,
    this.khan,
    this.commune,
    this.sangkat,
    this.village,
    this.reference,
    this.latitude,
    this.longitudes,
    this.abbreviation,
    this.eastEn,
    this.eastKh,
    this.westEn,
    this.westKh,
    this.southEn,
    this.southKh,
    this.northEn,
    this.northKh,
  });

  int? id;
  String? code;
  String? image;
  String? khmer;
  String? english;
  int? krong;
  int? srok;
  int? khan;
  int? commune;
  int? sangkat;
  int? village;
  String? reference;
  String? latitude;
  String? longitudes;
  String? abbreviation;
  @JsonKey(name: 'east_en')
  String? eastEn;
  @JsonKey(name: 'east_kh')
  String? eastKh;
  @JsonKey(name: 'west_en')
  String? westEn;
  @JsonKey(name: 'west_kh')
  String? westKh;
  @JsonKey(name: 'south_en')
  String? southEn;
  @JsonKey(name: 'south_kh')
  String? southKh;
  @JsonKey(name: 'north_en')
  String? northEn;
  @JsonKey(name: 'north_kh')
  String? northKh;

  factory TbProvinceModel.fromJson(Map<String, dynamic> json) => _$TbProvinceModelFromJson(json);
  Map<String, dynamic> toJson() => _$TbProvinceModelToJson(this);
}
