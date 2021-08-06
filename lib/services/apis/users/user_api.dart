import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:cambodia_geography/services/apis/base_resource_owner_api.dart';

class UserApi extends BaseResourceOwnerApi {
  @override
  bool get useJapx => false;

  @override
  String get nameInUrl => "user";

  Future<UserModel?> fetchCurrentUser() async {
    dynamic result = await super.fetchOne();
    if (result is UserModel) return result;
  }

  @override
  UserModel objectTransformer(Map<String, dynamic> json) {
    return UserModel.fromJson(json['data']);
  }
}
