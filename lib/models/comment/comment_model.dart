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
  User? user;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? id;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      type: json["type"],
      comment: json["comment"],
      user: User.fromJson(json["user"]),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
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

class User {
  User({
    this.username,
    this.profileImg,
    this.id,
  });

  String? username;
  ProfileImg? profileImg;
  String? id;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json["username"],
      profileImg: ProfileImg.fromJson(json["profile_img"] != null ? json["profile_img"] : null),
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "profile_img": profileImg?.toJson(),
      "id": id,
    };
  }
}

class ProfileImg {
  ProfileImg({
    this.type,
    this.id,
    this.url,
  });

  String? type;
  String? id;
  String? url;

  factory ProfileImg.fromJson(Map<String, dynamic> json) {
    return ProfileImg(
      type: json["type"],
      id: json["id"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "id": id,
      "url": url,
    };
  }
}
