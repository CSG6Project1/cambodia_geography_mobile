import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/services/apis/places/base_places_api.dart';

class SearchApi extends BasePlacesApi {
  @override
  String get nameInUrl => "searchplaces/result";

  @override
  PlaceModel objectTransformer(Map<String, dynamic> json) {
    return PlaceModel.fromJson(json);
  }

  @override
  PlaceListModel itemsTransformer(Map<String, dynamic> json) {
    return PlaceListModel(
      items: buildItems(json),
      meta: buildMeta(json),
      links: buildLinks(json),
    );
  }

  @override
  fetchAllPlaces({
    String? keyword,
    PlaceType? type,
    String? provinceCode,
    String? districtCode,
    String? villageCode,
    String? communeCode,
    String? page,
  }) {
    return super.fetchAll(queryParameters: {
      "keyword": keyword,
      "page": page,
    });
  }
}
