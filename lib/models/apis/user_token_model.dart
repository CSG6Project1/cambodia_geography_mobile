import 'package:json_annotation/json_annotation.dart';
part 'user_token_model.g.dart';

@JsonSerializable()
class UserTokenModel {
  UserTokenModel({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.refreshToken,
    this.createdAt,
  });

  @JsonKey(name: 'access_token')
  String? accessToken;
  @JsonKey(name: 'token_type')
  String? tokenType;
  @JsonKey(name: 'expires_in')
  int? expiresIn;
  @JsonKey(name: 'refresh_token')
  String? refreshToken;
  @JsonKey(name: 'created_at')
  int? createdAt;

  factory UserTokenModel.fromJson(Map<String, dynamic> json) => _$UserTokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserTokenModelToJson(this);
}
