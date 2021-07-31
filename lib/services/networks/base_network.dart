import 'package:cambodia_geography/services/networks/interceptors/default_interceptor.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class BaseNetwork {
  BaseNetwork() {
    retryCount = 0;
  }

  List<InterceptorContract> _interceptors = [
    DefaultInterceptor(),
  ];

  RetryPolicy? get retryPolicy => null;
  late int retryCount;

  Client? get http {
    return InterceptedClient.build(
      interceptors: _interceptors,
      retryPolicy: retryPolicy,
    );
  }

  void addInterceptor(InterceptorContract interceptor) {
    if (this._interceptors.contains(interceptor)) return;
    _interceptors.add(interceptor);
  }

  void removeInterceptor(InterceptorContract interceptor) {
    if (!this._interceptors.contains(interceptor)) return;
    _interceptors.remove(interceptor);
  }
}
