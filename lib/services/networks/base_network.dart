import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

abstract class BaseNetwork {
  List<InterceptorContract> _interceptors = [];
  RetryPolicy? get retryPolicy;

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
