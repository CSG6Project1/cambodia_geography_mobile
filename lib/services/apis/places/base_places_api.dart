import 'package:cambodia_geography/models/apis/links_model.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/services/apis/base_app_api.dart';

abstract class BasePlacesApi extends BaseAppApi<PlaceModel> {
  @override
  PlaceModel objectTransformer(Map<String, dynamic> json) {
    return PlaceModel.fromJson(json);
  }

  @override
  PlaceListModel itemsTransformer(Map<String, dynamic> json) {
    LinksModel? link = buildLinks(json);
    return PlaceListModel(
      meta: buildMeta(json),
      links: link,
      items: buildItems(json)?.map((e) {
        e.page = link?.getPageNumber().self;
        return e;
      }).toList(),
    );
  }

  bool get useJapx => false;
  fetchAllPlaces({
    String? keyword,
    PlaceType? type,
    String? provinceCode,
    String? districtCode,
    String? villageCode,
    String? communeCode,
    String? page,
  });
}
