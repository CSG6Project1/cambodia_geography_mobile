import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/services/apis/base_resource_owner_api.dart';

class BookmarkRemoveAllPlacesApi extends BaseResourceOwnerApi {
  @override
  String get nameInUrl => "bookmark/empty";

  Future<void> removeAllPlaces({
    PlaceType? type,
    String? page,
  }) {
    return super.fetchAll(queryParameters: {
      "type": type.toString().replaceAll("PlaceType.", ""),
      "page": page,
    });
  }

  @override
  objectTransformer(Map<String, dynamic> json) {
    return json;
  }
}
