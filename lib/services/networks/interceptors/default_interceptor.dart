import 'package:cambodia_geography/constants/api_constant.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/http_interceptor.dart';

class DefaultInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      data.baseUrl = ApiConstant.baseUrl;
    } catch (e) {}
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}
