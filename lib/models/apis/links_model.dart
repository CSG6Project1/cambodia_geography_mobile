import 'package:cambodia_geography/helpers/app_helper.dart';
import 'package:json_annotation/json_annotation.dart';
part 'links_model.g.dart';

@JsonSerializable()
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

  factory LinksModel.fromJson(Map<String, dynamic> json) => _$LinksModelFromJson(json);
  Map<String, dynamic> toJson() => _$LinksModelToJson(this);
}
