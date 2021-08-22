import 'package:cambodia_geography/models/apis/base_list_model.dart';
import 'package:cambodia_geography/models/apis/links_model.dart';
import 'package:cambodia_geography/models/apis/meta_model.dart';
import 'package:cambodia_geography/models/search/autocompleter_model.dart';

class AutocompleterListModel extends BaseListModel<AutocompleterModel> {
  AutocompleterListModel({
    List<AutocompleterModel>? items,
    MetaModel? meta,
    LinksModel? links,
  }) : super(items: items, meta: meta, links: links);
}