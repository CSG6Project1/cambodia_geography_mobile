import 'package:cambodia_geography/services/networks/base_network.dart';
import 'package:http_interceptor/models/retry_policy.dart';

class AppNetwork extends BaseNetwork {
  @override
  RetryPolicy? get retryPolicy => null;
}
