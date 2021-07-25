import 'dart:convert';

import 'package:cambodia_geography/models/apis/user_token_model.dart';
import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:http_interceptor/http_interceptor.dart';

class RefreshTokenPolicy extends RetryPolicy {
  AuthApi auth = AuthApi();

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    print("WOWOWO");
    if (response.statusCode == 401) {
      if (response.body != null) {
        final json = jsonDecode(response.body!);
        if (json['message'] == "JWT expired") {
          UserTokenModel? model = await auth.getCurrentUserToken();
          if (model?.refreshToken == null) return false;
          await auth.reAuthenticate(refreshToken: model!.refreshToken!);
          return true;
        }
      }
    }
    return false;
  }
}
