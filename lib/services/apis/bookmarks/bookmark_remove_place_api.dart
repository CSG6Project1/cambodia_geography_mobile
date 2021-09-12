import 'package:cambodia_geography/services/apis/base_resource_owner_api.dart';

class BookmarkRemovePlaceApi extends BaseResourceOwnerApi {
  @override
  String get nameInUrl => "bookmark/remove_place";

  Future<void> removePlace({
    String? id,
  }) {
    return super.delete(id: id);
  }

  @override
  objectTransformer(Map<String, dynamic> json) {
    return json;
  }
}
