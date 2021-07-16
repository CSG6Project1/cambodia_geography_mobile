class MetaModel {
  MetaModel({
    this.count,
    this.totalCount,
    this.totalPages,
  });

  int? count;
  int? totalCount;
  int? totalPages;

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      count: json["count"],
      totalCount: json["total_count"],
      totalPages: json["total_pages"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "count": count,
      "total_count": totalCount,
      "total_pages": totalPages,
    };
  }
}
