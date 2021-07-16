import 'package:cambodia_geography/services/apis/base_api.dart';
import 'package:cambodia_geography/services/networks/app_network.dart';
import 'package:cambodia_geography/services/networks/base_network.dart';

abstract class BaseAppApi<T> extends BaseApi<T> {
  @override
  BaseNetwork buildNetwork() {
    return AppNetwork();
  }
}
