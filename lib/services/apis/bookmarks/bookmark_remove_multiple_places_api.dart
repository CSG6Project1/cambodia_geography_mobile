import 'package:cambodia_geography/services/apis/base_resource_owner_api.dart';

class BookmarkRemoveMultiplePlacesApi extends BaseResourceOwnerApi {
  @override
  String get nameInUrl => "bookmark/remove_places";

  Future<void> removeMultiplePlaces({
    required List<String> placeIds,
  }) {
    return super.delete(
      body: {
        "placeId": placeIds,
      },
    );
  }

  @override
  objectTransformer(Map<String, dynamic> json) {
    return json;
  }
}
