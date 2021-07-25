import 'package:cambodia_geography/models/apis/user_token_model.dart';
import 'package:cambodia_geography/services/apis/base_api.dart';
import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:cambodia_geography/services/networks/base_network.dart';
import 'package:cambodia_geography/services/networks/user_token_network.dart';
import 'package:http/http.dart';

abstract class BaseResourceOwnerApi<T> extends BaseApi<T> {
  @override
  BaseNetwork buildNetwork() {
    return UserTokenNetwork();
  }

  @override
  Future<MultipartRequest> multipartRequest({required MultipartRequest request}) async {
    UserTokenModel? model = await AuthApi().getCurrentUserToken();
    if (model?.accessToken != null) {
      request.headers["Authorization"] = "Bearer ${model?.accessToken}";
    }
    return request;
  }
}
