import 'package:cambodia_geography/models/info/member_model.dart';
import 'package:cambodia_geography/services/apis/base_app_api.dart';

class MemberApi extends BaseAppApi<MemberModel> {
  @override
  bool get useJapx => false;

  @override
  String get nameInUrl => "members";

  @override
  MemberModel objectTransformer(Map<String, dynamic> json) {
    return MemberModel.fromJson(json);
  }

  Future<dynamic> fetchAllMember() async {
    return await super.fetchAll();
  }

  @override
  dynamic itemsTransformer(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] is List) {
      return buildItems(json);
    }
  }
}
