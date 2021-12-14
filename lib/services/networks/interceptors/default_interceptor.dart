import 'package:http_interceptor/http_interceptor.dart';

class DefaultInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      data.headers["Content-Type"] = "application/json";
    } catch (e) {}
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}
