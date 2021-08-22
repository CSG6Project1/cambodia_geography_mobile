import 'package:cambodia_geography/models/image_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    this.role,
    this.username,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.profileImg,
    this.id,
  });

  String? role;
  String? username;
  String? email;
  @JsonKey(name: 'create_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  @JsonKey(name: 'profile_img')
  ImageModel? profileImg;
  String? id;

  List<String> paramNames() {
    return [
      'role',
      'username',
      'email',
    ];
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
