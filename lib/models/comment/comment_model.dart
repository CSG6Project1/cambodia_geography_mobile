import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  CommentModel({
    this.type,
    this.comment,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  String? type;
  String? comment;
  UserModel? user;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  String? id;

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
