import 'package:json_annotation/json_annotation.dart';
part 'autocompleter_model.g.dart';

@JsonSerializable()
class AutocompleterModel {
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
}