import 'package:cambodia_geography/models/apis/user_token_model.dart';
import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:http_interceptor/http_interceptor.dart';

class UserTokenInterceptor implements InterceptorContract {
  AuthApi authApi = AuthApi();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      UserTokenModel? model = await authApi.getCurrentUserToken();
      if (model?.accessToken != null) {
        data.headers["Authorization"] = "Bearer ${model?.accessToken}";
      }
    } catch (e) {}
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}
