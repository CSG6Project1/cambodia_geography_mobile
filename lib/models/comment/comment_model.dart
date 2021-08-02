import 'package:cambodia_geography/models/user/user_model.dart';

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
  DateTime? createdAt;
  DateTime? updatedAt;
  String? id;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      type: json["type"],
      comment: json["comment"],
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
      createdAt: DateTime.tryParse(json["created_at"]),
      updatedAt: DateTime.tryParse(json["updated_at"]),
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "comment": comment,
      "user": user?.toJson(),
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "id": id,
    };
  }
}
