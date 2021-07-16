import 'package:cambodia_geography/services/apis/base_api.dart';
import 'package:cambodia_geography/services/networks/user_token_network.dart';

abstract class BaseResourceOwnerApi extends BaseApi {
  @override
  buildNetwork() {
    return UserTokenNetwork();
  }
}
