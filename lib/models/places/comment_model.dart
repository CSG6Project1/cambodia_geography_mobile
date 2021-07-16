class CommentModel {
  CommentModel({
    this.createdAt,
    this.updatedAt,
    this.type,
    this.comment,
    this.user,
    this.id,
  });

  DateTime? createdAt;
  DateTime? updatedAt;
  String? type;
  String? comment;
  String? user;
  String? id;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      type: json["type"],
      comment: json["comment"],
      user: json["user"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "type": type,
      "comment": comment,
      "user": user,
      "id": id,
    };
  }
}
