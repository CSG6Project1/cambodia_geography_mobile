class ProfileImgModel {
  ProfileImgModel({
    this.type,
    this.id,
    this.url,
  });

  String? type;
  String? id;
  String? url;

  factory ProfileImgModel.fromJson(Map<String, dynamic> json) {
    return ProfileImgModel(
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
