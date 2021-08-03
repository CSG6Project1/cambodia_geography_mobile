import 'dart:convert';
import 'dart:io';
import 'package:cambodia_geography/constants/api_constant.dart';
import 'package:cambodia_geography/models/apis/links_model.dart';
import 'package:cambodia_geography/models/apis/meta_model.dart';
import 'package:cambodia_geography/models/apis/object_name_url_model.dart';
import 'package:cambodia_geography/models/apis/user_token_model.dart';
import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:cambodia_geography/services/networks/base_network.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class CgContentType {
  String type;
  CgContentType(this.type);

  static const String png = 'image/png';
  static const String jpg = 'image/jpg';
  static const String jpeg = 'image/jpeg';
  static const String gif = 'image/gif';
}

abstract class BaseApi<T> {
  Response? response;
  StreamedResponse? streamedResponse;
  BaseNetwork? network;
  BaseNetwork buildNetwork();

  MultipartRequest? _multipartRequest;

  BaseApi() {
    network = buildNetwork();
  }

  bool success() {
    if (this.response == null) return false;
    if (this.response != null) {
      return this.response!.statusCode >= 200 && this.response!.statusCode < 300;
    }
    return false;
  }

  String? message() {
    if (response?.body == null) return null;
    dynamic json = jsonDecode(response!.body);
    if (json is Map && json.containsKey('message')) {
      return json['message'];
    }
  }

  Future<MultipartRequest> multipartRequest({
    required MultipartRequest request,
  }) async {
    return request;
  }

  Future<dynamic> _beforeExec(Future<dynamic> Function() body) async {
    this.response = null;
    this.streamedResponse = null;
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

  Future<dynamic> send({
    required String method,
    required Map<String, String> fields,
    required List<File> files,
    required String fileField,
    required CgContentType fileContentType,
  }) async {
    return _beforeExec(() async {
      Uri postUri = Uri.parse(this.objectNameUrlModel.createUrl());
      _multipartRequest = MultipartRequest(method, postUri);
      _multipartRequest = await multipartRequest(request: _multipartRequest!);
      _multipartRequest?.fields.addAll(fields);

      files.forEach((file) async {
        MultipartFile multipart = await MultipartFile.fromPath(
          fileField,
          file.path,
          filename: basename(file.path),
          contentType: MediaType.parse(fileContentType.type),
        );
        _multipartRequest?.files.add(multipart);
      });

      streamedResponse = await network?.http?.send(_multipartRequest!);
      String? respStr = await streamedResponse?.stream.bytesToString();

      if (respStr != null && streamedResponse?.statusCode != null) {
        this.response = Response(
          respStr,
          streamedResponse!.statusCode,
        );
      }
    });
  }

  Future<dynamic> fetchOne({required String id}) async {
    return _beforeExec(() async {
      String endpoint = objectNameUrlModel.fetchOneUrl(id: id);
      response = await network?.http?.get(Uri.parse(endpoint));
    });
  }

  Future<dynamic> fetchAll({Map<String, dynamic>? queryParameters}) async {
    return _beforeExec(() async {
      String endpoint = objectNameUrlModel.fetchAllUrl(queryParameters: queryParameters);
      response = await network?.http?.get(Uri.parse(endpoint));
      dynamic json = jsonDecode(response?.body.toString() ?? "");
      return itemsTransformer(json);
    });
  }

  Future<dynamic> update() {
    return _beforeExec(() async {});
  }

  Future<dynamic> create({Map<String, dynamic>? body}) {
    return _beforeExec(() async {
      Uri endPoint = Uri.parse(this.objectNameUrlModel.createUrl());
      UserTokenModel? model = await AuthApi().getCurrentUserToken();
      response = await network?.http?.post(
        endPoint,
        body: jsonEncode(body),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "${model?.accessToken}",
        },
      );
      dynamic json = jsonDecode(response?.body.toString() ?? '');
      print('json decode: $json');
      return itemsTransformer(json);
    });
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
