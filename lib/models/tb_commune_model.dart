import 'package:json_annotation/json_annotation.dart';
part 'tb_commune_model.g.dart';

@JsonSerializable()
class TbCommuneModel {
  TbCommuneModel({
    this.id,
    this.districtCode,
    this.code,
    this.type,
    this.khmer,
    this.english,
    this.village,
    this.reference,
    this.officialNote,
    this.noteByChecker,
  });

  int? id;
  @JsonKey(name: 'district_code')
  String? districtCode;
  String? code;
  String? type;
  String? khmer;
  String? english;
  int? village;
  String? reference;
  @JsonKey(name: 'official_note')
  String? officialNote;
  @JsonKey(name: 'note_by_checker')
  String? noteByChecker;

  factory TbCommuneModel.fromJson(Map<String, dynamic> json) => _$TbCommuneModelFromJson(json);
  Map<String, dynamic> toJson() => _$TbCommuneModelToJson(this);
}
