import 'package:cambodia_geography/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'tb_village_model.g.dart';

@JsonSerializable()
class TbVillageModel extends BaseModel {
  TbVillageModel({
    this.id,
    this.communeCode,
    this.code,
    this.khmer,
    this.english,
    this.reference,
    this.officialNote,
    this.noteByChecker,
  });

  int? id;
  @JsonKey(name: 'commune_code')
  String? communeCode;
  String? code;
  String? khmer;
  String? english;
  String? reference;
  @JsonKey(name: 'official_note')
  String? officialNote;
  @JsonKey(name: 'note_by_checker')
  String? noteByChecker;

  factory TbVillageModel.fromJson(Map<String, dynamic> json) => _$TbVillageModelFromJson(json);
  Map<String, dynamic> toJson() => _$TbVillageModelToJson(this);

  @override
  String? get en => this.english;

  @override
  String? get km => this.khmer;
}
