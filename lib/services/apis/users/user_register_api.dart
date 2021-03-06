import 'package:cambodia_geography/services/apis/base_app_api.dart';

class UserRegisterApi extends BaseAppApi {
  @override
  String get nameInUrl => "user/register";

  Future<dynamic> register({
    required String username,
    required String email,
    required String password,
  }) async {
    Map<String, String> body = {
      "username": username,
      "email": email,
      "password": password,
      "grant_type": "password",
    };
    return await super.create(
      body: body,
    );
  }

  Future<dynamic> registerWithSocial({
    required String username,
    required String idToken,
  }) async {
    Map<String, String> body = {
      "username": username,
      "id_token": idToken,
      "grant_type": "credential",
    };
    return await super.create(body: body);
  }

  @override
  objectTransformer(Map<String, dynamic> json) {
    return json;
  }
}
