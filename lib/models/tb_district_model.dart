import 'package:cambodia_geography/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'tb_district_model.g.dart';

@JsonSerializable()
class TbDistrictModel extends BaseModel {
  TbDistrictModel({
    this.id,
    this.provinceCode,
    this.code,
    this.type,
    this.khmer,
    this.english,
    this.commune,
    this.sangkat,
    this.village,
    this.reference,
    this.officialNote,
    this.noteByChecker,
  });

  int? id;
  @JsonKey(name: 'province_code')
  String? provinceCode;
  String? code;
  String? type;
  String? khmer;
  String? english;
  int? commune;
  int? sangkat;
  int? village;
  String? reference;
  @JsonKey(name: 'official_note')
  String? officialNote;
  @JsonKey(name: 'note_by_checker')
  String? noteByChecker;

  factory TbDistrictModel.fromJson(Map<String, dynamic> json) => _$TbDistrictModelFromJson(json);
  Map<String, dynamic> toJson() => _$TbDistrictModelToJson(this);

  @override
  String? get en => this.english;

  @override
  String? get km => this.khmer;
}
