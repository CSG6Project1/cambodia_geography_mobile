import 'package:cambodia_geography/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'autocompleter_model.g.dart';

@JsonSerializable()
class AutocompleterModel extends BaseModel {
  AutocompleterModel({
    this.type,
    this.khmer,
    this.english,
    this.id,
  });

  @JsonKey(name: "_id")
  String? id;
  String? khmer;
  String? english;
  String? type;

  factory AutocompleterModel.fromJson(Map<String, dynamic> json) => _$AutocompleterModelFromJson(json);
  Map<String, dynamic> toJson() => _$AutocompleterModelToJson(this);

  @override
  String? get en => this.english;

  @override
  String? get km => this.khmer;
}
