import 'package:cambodia_geography/models/apis/base_list_model.dart';
import 'package:cambodia_geography/models/apis/links_model.dart';
import 'package:cambodia_geography/models/apis/meta_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';

class PlaceListModel extends BaseListModel<PlaceModel> {
  PlaceListModel({
    List<PlaceModel>? items,
    MetaModel? meta,
    LinksModel? links,
  }) : super(items: items, meta: meta, links: links);
}
