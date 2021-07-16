import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/services/apis/base_app_api.dart';

class PlacesApi extends BaseAppApi<PlaceModel> {
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
}
