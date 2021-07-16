import 'dart:convert';
import 'dart:io';
import 'package:cambodia_geography/constants/api_constant.dart';
import 'package:cambodia_geography/models/apis/links_model.dart';
import 'package:cambodia_geography/models/apis/meta_model.dart';
import 'package:cambodia_geography/models/apis/object_name_url_model.dart';
import 'package:cambodia_geography/services/networks/base_network.dart';
import 'package:http/http.dart';

abstract class BaseApi<T> {
  Response? response;
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

  Future<dynamic> _beforeExec(Future<dynamic> Function() body) async {
    this.response = null;
    try {
      return await body();
    } on SocketException {
      return Future.error('No Internet connection');
    } on FormatException {
      return Future.error('Bad response format');
    } on Exception {
      return Future.error('Unexpected error');
    }
  }

  Future<dynamic> fetchOne({required String id}) async {
    return _beforeExec(() async {
      String endpoint = objectNameUrlModel.fetchOneUrl(id: id);
      response = await network?.http?.get(Uri.parse(endpoint));
    });
  }

  Future<dynamic> fetchAll() async {
    return _beforeExec(() async {
      String endpoint = objectNameUrlModel.fetchAllUrl();
      response = await network?.http?.get(Uri.parse(endpoint));
      dynamic json = jsonDecode(response?.body.toString() ?? "");
      return itemsTransformer(json);
    });
  }

  Future<dynamic> update() {
    return _beforeExec(() async {});
  }

  Future<dynamic> create() {
    return _beforeExec(() async {});
  }

  Future<dynamic> delete() {
    return _beforeExec(() async {});
  }

  T objectTransformer(Map<String, dynamic> json);
  itemsTransformer(Map<String, dynamic> json) {}

  List<T>? buildItems(Map<String, dynamic> json) {
    if (json.containsKey('data') && json['data'] != null) {
      List data = json['data'];
      List<T> items = [];
      data.forEach((item) {
        try {
          Map<String, dynamic>? attrs = item;
          T record = objectTransformer(attrs ?? {});
          items.add(record);
        } catch (e) {}
      });
      return items;
    }
  }

  MetaModel? buildMeta(Map<String, dynamic> json) {
    if (json.containsKey('meta') && json['meta'] != null) {
      try {
        return MetaModel.fromJson(json['meta']);
      } catch (e) {}
    }
  }

  LinksModel? buildLinks(Map<String, dynamic> json) {
    if (json.containsKey('links') && json['links'] != null) {
      try {
        return LinksModel.fromJson(json['links']);
      } catch (e) {}
    }
  }

  String get nameInUrl;
  String get baseUrl => ApiConstant.baseUrl;

  ObjectNameUrlModel get objectNameUrlModel {
    return ObjectNameUrlModel(nameInUrl: nameInUrl, path: "", baseUrl: baseUrl);
  }
}
