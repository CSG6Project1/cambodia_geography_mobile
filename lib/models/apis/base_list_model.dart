import 'package:cambodia_geography/models/apis/links_model.dart';
import 'package:cambodia_geography/models/apis/meta_model.dart';

abstract class BaseListModel<T> {
  List<T>? items;
  MetaModel? meta;
  LinksModel? links;

  BaseListModel({
    this.items,
    this.meta,
    this.links,
  });

  BaseListModel add(BaseListModel newList) {
    if (newList.items != null) this.items?.addAll(newList.items as List<T>);
    this.links = newList.links;
    this.meta = newList.meta;
    return this;
  }

  bool hasLoadMore() {
    if (this.items == null && this.meta == null) return false;
    if (this.items!.length < this.meta!.totalCount!) {
      return true;
    } else
      return false;
  }
}
