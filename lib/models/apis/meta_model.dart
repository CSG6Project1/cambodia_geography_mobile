import 'package:json_annotation/json_annotation.dart';
part 'meta_model.g.dart';

@JsonSerializable()
class MetaModel {
  MetaModel({
    this.count,
    this.totalCount,
    this.totalPages,
  });

  int? count;
  @JsonKey(name: 'total_count')
  int? totalCount;
  @JsonKey(name: 'total_pages')
  int? totalPages;

  factory MetaModel.fromJson(Map<String, dynamic> json) => _$MetaModelFromJson(json);
  Map<String, dynamic> toJson() => _$MetaModelToJson(this);
}
