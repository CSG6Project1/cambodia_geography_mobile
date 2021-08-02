import 'package:cambodia_geography/models/user/profile_img_model.dart';

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
  DateTime? createdAt;
  DateTime? updatedAt;
  ProfileImgModel? profileImg;
  String? id;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      role: json["role"],
      username: json["username"],
      email: json["email"],
      createdAt: DateTime.tryParse(json["created_at"]),
      updatedAt: DateTime.tryParse(json["updated_at"]),
      profileImg: ProfileImgModel.fromJson(json["profile_img"]),
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "username": username,
      "email": email,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "profile_img": profileImg?.toJson(),
      "id": id,
    };
  }
}
