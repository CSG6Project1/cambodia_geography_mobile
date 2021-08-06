import 'package:cambodia_geography/services/apis/base_resource_owner_api.dart';

class CrudCommentApi extends BaseResourceOwnerApi {
  Future<dynamic> createComment({
    required String placeId,
    required String comment,
  }) async {
    return await super.create(body: {
      'placeId': placeId,
      'comment': comment,
    });
  }

  @override
  String get nameInUrl => 'comment';

  @override
  String? objectTransformer(Map<String, dynamic> json) {
    return json["message"];
  }
}
