class ImageModel {
  String? type;
  String? id;
  String? url;

  ImageModel({
    this.type,
    this.id,
    this.url,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
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
