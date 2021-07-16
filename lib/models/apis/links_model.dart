import 'package:cambodia_geography/helper/app_helper.dart';

class LinksModel {
  LinksModel({
    this.self,
    this.next,
    this.first,
    this.last,
  });

  String? self;
  String? next;
  String? first;
  String? last;

  LinksModel getPageNumber() {
    return LinksModel(
      first: AppHelper.queryParameters(url: this.first ?? "", param: 'page'),
      last: AppHelper.queryParameters(url: this.last ?? "", param: 'page'),
      next: AppHelper.queryParameters(url: this.next ?? "", param: 'page'),
      self: AppHelper.queryParameters(url: this.self ?? "", param: 'page'),
    );
  }

  factory LinksModel.fromJson(Map<String, dynamic> json) {
    return LinksModel(
      self: json["self"],
      next: json["next"],
      first: json["first"],
      last: json["last"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "self": self,
      "next": next,
      "first": first,
      "last": last,
    };
  }
}
