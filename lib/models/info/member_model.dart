import 'package:cambodia_geography/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'member_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MemberModel extends BaseModel {
  final String? khmer;
  final String? english;
  final String? roleKhmer;
  final String? roleEnglish;
  final String? github;
  final String? profile;

  MemberModel({
    this.khmer,
    this.english,
    this.roleKhmer,
    this.roleEnglish,
    this.github,
    this.profile,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) => _$MemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$MemberModelToJson(this);

  String? get roleTr => super.tr(roleKhmer, roleEnglish);

  @override
  String? get en => this.khmer;

  @override
  String? get km => this.khmer;
}
