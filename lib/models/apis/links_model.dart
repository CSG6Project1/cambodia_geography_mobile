import 'package:cambodia_geography/helper/app_helper.dart';

class LinksModel {
  LinksModel({
    this.self,
    this.prev,
    this.next,
    this.first,
    this.last,
  });

  String? self;
  String? prev;
  String? next;
  String? first;
  String? last;

  LinksModel getPageNumber() {
    return LinksModel(
      self: AppHelper.queryParameters(url: this.self ?? "", param: 'page'),
      prev: AppHelper.queryParameters(url: this.prev ?? "", param: 'page'),
      next: AppHelper.queryParameters(url: this.next ?? "", param: 'page'),
      first: AppHelper.queryParameters(url: this.first ?? "", param: 'page'),
      last: AppHelper.queryParameters(url: this.last ?? "", param: 'page'),
    );
  }

  factory LinksModel.fromJson(Map<String, dynamic> json) {
    return LinksModel(
      self: json["self"],
      prev: json["prev"],
      next: json["next"],
      first: json["first"],
      last: json["last"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "self": self,
      "prev": prev,
      "next": next,
      "first": first,
      "last": last,
    };
  }
}
