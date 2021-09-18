import 'package:cambodia_geography/services/apis/base_resource_owner_api.dart';

class BookmarkRemoveAllPlacesApi extends BaseResourceOwnerApi {
  @override
  String get nameInUrl => "bookmark/empty";

  Future<void> removeAllPlaces() {
    return super.delete();
  }

  @override
  objectTransformer(Map<String, dynamic> json) {
    return json;
  }
}
