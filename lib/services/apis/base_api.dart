import 'package:cambodia_geography/constants/api_constant.dart';
import 'package:cambodia_geography/models/apis/object_name_url_model.dart';
import 'package:cambodia_geography/services/networks/base_network.dart';
import 'package:http/http.dart' as http;

abstract class BaseApi {
  http.Response? response;
  BaseNetwork? network;
  BaseNetwork buildNetwork();

  BaseApi() {
    network = buildNetwork();
  }

  bool success() {
    if (this.response == null) return false;
    return this.response!.statusCode >= 200 && this.response!.statusCode < 300;
  }

  String? errorMessage() {
    return response?.body;
  }

  fetchOne({required String id}) async {
    String endpoint = objectNameUrlModel.fetchOneUrl(id: id);
    response = await network?.http?.get(Uri.parse(endpoint));
  }

  fetchAll() async {
    String endpoint = objectNameUrlModel.fetchAllUrl();
    print(endpoint);
    response = await network?.http?.get(Uri.parse(endpoint));
    return response;
  }

  update() {}

  create() {}

  delete() {}

  String get nameInUrl;
  String get baseUrl => ApiConstant.baseUrl;

  ObjectNameUrlModel get objectNameUrlModel {
    return ObjectNameUrlModel(nameInUrl: nameInUrl, path: "", baseUrl: baseUrl);
  }
}
