import 'package:json_annotation/json_annotation.dart';
part 'bookmark_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BookmarkModel {
  BookmarkModel({
    this.id,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  DateTime? createdAt;
  DateTime? updatedAt;

  String? id;
  String? user;

  factory BookmarkModel.fromJson(Map<String, dynamic> json) => _$BookmarkModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkModelToJson(this);
}
