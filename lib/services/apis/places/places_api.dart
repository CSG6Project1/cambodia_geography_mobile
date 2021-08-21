import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/services/apis/places/base_places_api.dart';

class PlacesApi extends BasePlacesApi {
  @override
  String get nameInUrl => "places";

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
      "type": type.toString().replaceAll("PlaceType.", ""),
      "province_code": provinceCode,
      "district_code": districtCode,
      "village_code": villageCode,
      "commune_code": communeCode,
      "page": page,
    });
  }
}
