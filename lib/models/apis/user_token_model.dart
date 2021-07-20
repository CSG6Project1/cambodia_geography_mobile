class UserTokenModel {
  UserTokenModel({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.refreshToken,
    this.createdAt,
  });

  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? refreshToken;
  int? createdAt;

  factory UserTokenModel.fromJson(Map<String, dynamic> json) {
    return UserTokenModel(
      accessToken: json["access_token"],
      tokenType: json["token_type"],
      expiresIn: json["expires_in"],
      refreshToken: json["refresh_token"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "access_token": accessToken,
      "token_type": tokenType,
      "expires_in": expiresIn,
      "refresh_token": refreshToken,
      "created_at": createdAt,
    };
  }
}
