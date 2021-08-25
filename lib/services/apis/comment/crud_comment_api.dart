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

  Future<dynamic> updateComment({required String id, required String comment}) async {
    return await super.update(id: id, body: {'comment': comment});
  }

  Future<dynamic> deleteComment({required String id}) async {
    return await super.delete(id: id);
  }

  @override
  String get nameInUrl => 'comment';

  @override
  String? objectTransformer(Map<String, dynamic> json) {
    return json["message"];
  }
}
