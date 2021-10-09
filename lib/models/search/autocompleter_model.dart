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
    this.shouldDisplayType = false,
  });

  @JsonKey(name: "_id")
  String? id;
  String? khmer;
  String? english;
  String? type;
  bool? shouldDisplayType;

  factory AutocompleterModel.fromJson(Map<String, dynamic> json) => _$AutocompleterModelFromJson(json);
  Map<String, dynamic> toJson() => _$AutocompleterModelToJson(this);

  AutocompleterModel copyWith({
    String? id,
    String? khmer,
    String? english,
    String? type,
    bool? shouldDisplayType,
  }) {
    return AutocompleterModel(
      id: id ?? this.id,
      khmer: khmer ?? this.khmer,
      english: english ?? this.english,
      type: type ?? this.type,
      shouldDisplayType: shouldDisplayType ?? this.shouldDisplayType,
    );
  }

  @override
  String? get en => this.english;

  @override
  String? get km => this.khmer;
}
