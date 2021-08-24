import 'package:cambodia_geography/models/image_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  UserModel({
    this.role,
    this.username,
    this.oldPassword,
    this.newPassword,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.profileImg,
    this.id,
    this.isVerify,
  });

  String? role;
  String? username;
  String? oldPassword;
  String? newPassword;
  String? email;
  @JsonKey(name: 'create_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  @JsonKey(name: 'profile_img')
  ImageModel? profileImg;
  String? id;
  bool? isVerify;

  List<String> paramNames() {
    return [
      'username',
      'new_password',
      'old_password',
    ];
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
