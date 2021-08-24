import 'dart:io';

import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:cambodia_geography/services/apis/base_api.dart';
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

  Map<String, String> getFields(UserModel user) {
    Map<String, dynamic> _json = super.sliceParams(user.toJson(), user.paramNames())
      ..removeWhere((key, value) {
        return value == null;
      });

    Map<String, String> fields = Map.fromIterable(
      _json.entries,
      key: (e) => "${e.key}",
      value: (e) => "${e.value}",
    );

    return fields;
  }

  Future<void> updateProfile({
    required UserModel user,
    File? image,
  }) async {
    assert(user.id != null);
    return super.send(
      method: "PUT",
      fileField: "image",
      files: image != null ? [image] : [],
      fields: getFields(user),
      id: user.id,
      fileContentType: CgContentType(CgContentType.jpeg),
    );
  }

  @override
  UserModel? objectTransformer(Map<String, dynamic> json) {
    if (json.containsKey('data')) {
      return UserModel.fromJson(json['data']);
    }
  }
}
