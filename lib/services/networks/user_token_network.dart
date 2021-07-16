import 'package:cambodia_geography/services/networks/retry_policy/refresh_token_policy.dart';
import 'package:cambodia_geography/services/networks/interceptors/user_token_interceptor.dart';
import 'package:cambodia_geography/services/networks/base_network.dart';
import 'package:http_interceptor/http_interceptor.dart';

class UserTokenNetwork extends BaseNetwork {
  UserTokenNetwork() {
    this.addInterceptor(UserTokenInterceptor());
  }

  @override
  RetryPolicy? get retryPolicy => RefreshTokenPolicy();
}
