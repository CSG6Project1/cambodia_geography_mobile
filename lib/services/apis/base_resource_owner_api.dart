import 'package:cambodia_geography/services/apis/base_api.dart';
import 'package:cambodia_geography/services/networks/user_token_network.dart';

abstract class BaseResourceOwnerApi<T> extends BaseApi<T> {
  @override
  buildNetwork() {
    return UserTokenNetwork();
  }
}
