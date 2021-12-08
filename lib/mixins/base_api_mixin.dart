import 'dart:convert';
import 'package:cambodia_geography/services/storages/default_response_storage.dart';
import 'package:http/http.dart';

mixin BaseApiMixin {
  Future<void> writeResponseToStorage(Response? response, String? endpoint) async {
    if (endpoint == null) return;
    if (response?.body != null) {
      DefaultResponseStorage _defaultResponseStorage = DefaultResponseStorage(endpoint);
      await _defaultResponseStorage.write(response!.body);
    }
  }

  Future<Response?> readResponseFromStorage(Response? response, String? endpoint) async {
    if (endpoint == null) return null;

    DefaultResponseStorage _defaultResponseStorage = DefaultResponseStorage(endpoint);
    dynamic body = await _defaultResponseStorage.read();

    if (body != null) {
      Response response = Response.bytes(utf8.encode(body), 200);
      return response;
    }
  }
}
