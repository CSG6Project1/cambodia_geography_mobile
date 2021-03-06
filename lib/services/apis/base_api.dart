import 'dart:convert';
import 'dart:io';
import 'package:cambodia_geography/constants/api_constant.dart';
import 'package:cambodia_geography/helpers/app_helper.dart';
import 'package:cambodia_geography/models/apis/links_model.dart';
import 'package:cambodia_geography/models/apis/meta_model.dart';
import 'package:cambodia_geography/models/apis/object_name_url_model.dart';
import 'package:cambodia_geography/mixins/base_api_mixin.dart';
import 'package:cambodia_geography/services/networks/base_network.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:japx/japx.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class CgContentType {
  final String type;
  const CgContentType(this.type);

  static const String png = 'image/png';
  static const String jpg = 'image/jpg';
  static const String jpeg = 'image/jpeg';
  static const String gif = 'image/gif';
}

abstract class BaseApi<T> with BaseApiMixin {
  Response? response;
  StreamedResponse? streamedResponse;
  BaseNetwork? network;
  BaseNetwork buildNetwork();

  MultipartRequest? _multipartRequest;

  bool get useJapx => true;

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
    try {
      dynamic json = jsonDecode(response!.body);
      if (json is Map && json.containsKey('message')) {
        return json['message'];
      }
    } catch (e) {
      return null;
    }
  }

  Future<MultipartRequest> multipartRequest({
    required MultipartRequest request,
  }) async {
    return request;
  }

  Future<dynamic> _beforeExec(String? endpoint, Future<dynamic> Function() body) async {
    this.response = null;
    this.streamedResponse = null;
    dynamic _body;

    try {
      _body = await body();
      await writeResponseToStorage(response, endpoint);
    } on SocketException {
      await readResponseFromStorage(response, endpoint).then((value) {
        this.response = value;
      });
    } on FormatException {
      return Future.error('Bad response format');
    } on Exception {
      return Future.error('Unexpected error');
    }

    if (this.response == null && this.streamedResponse == null) return Future.error('Error');
    return _body;
  }

  Future<dynamic> send({
    required String method,
    String? id,
    Map<String, String> fields = const {},
    List<File> files = const [],
    String fileField = "",
    CgContentType fileContentType = const CgContentType(CgContentType.jpg),
    Map<String, dynamic>? queryParameters,
  }) async {
    List<String> methods = ["POST", "PUT"];
    assert(methods.contains(method));

    return _beforeExec('', () async {
      Uri postUri;

      switch (method) {
        case "POST":
          assert(id == null);
          postUri = Uri.parse(this.objectNameUrlModel.createUrl(queryParameters: queryParameters));
          break;
        case "PUT":
          assert(id != null);
          postUri = Uri.parse(this.objectNameUrlModel.updatelUrl(queryParameters: queryParameters, id: id));
          break;
        default:
          assert(id == null);
          postUri = Uri.parse(this.objectNameUrlModel.createUrl(queryParameters: queryParameters));
          break;
      }

      _multipartRequest = MultipartRequest(method, postUri);
      _multipartRequest = await multipartRequest(request: _multipartRequest!);
      _multipartRequest?.fields.addAll(fields..removeWhere((key, value) => value.isEmpty));

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
        this.response = Response(respStr, streamedResponse!.statusCode);

        // while retry interceptor is not work yet for send, we made this for tmr use.
        ResponseData responseData = ResponseData.fromHttpResponse(this.response!);
        bool? shouldRetry = await this.network?.retryPolicy?.shouldAttemptRetryOnResponse(responseData);
        if (1 >= this.network!.retryCount && shouldRetry == true) {
          return await send(
            method: method,
            fields: fields,
            files: files,
            fileField: fileField,
            fileContentType: fileContentType,
          );
        }
      }
    });
  }

  Future<dynamic> fetchOne({
    String? id,
    Map<String, dynamic>? queryParameters,
  }) async {
    String endpoint = objectNameUrlModel.fetchOneUrl(id: id, queryParameters: queryParameters);

    await _beforeExec(endpoint, () async {
      response = await network?.http?.get(Uri.parse(endpoint));
    });

    dynamic json = jsonDecode(response?.body.toString() ?? "");
    if (json is Map<String, dynamic>) {
      if (json.containsKey('data')) json = useJapx ? Japx.decode(json) : json;
      return objectTransformer(json);
    }
  }

  Future<dynamic> fetchAll({
    Map<String, dynamic>? queryParameters,
  }) async {
    queryParameters = buildFetchAlQueryParameters(queryParameters);
    String endpoint = objectNameUrlModel.fetchAllUrl(queryParameters: queryParameters);

    await _beforeExec(endpoint, () async {
      response = await network?.http?.get(Uri.parse(endpoint));
    });

    dynamic json = jsonDecode(response?.body.toString() ?? "");
    json = useJapx ? Japx.decode(json) : json;
    return itemsTransformer(json);
  }

  Future<dynamic> update({
    required String id,
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
  }) async {
    String endpoint = objectNameUrlModel.updatelUrl(id: id, queryParameters: queryParameters);

    await _beforeExec(endpoint, () async {
      response = await network?.http?.put(Uri.parse(endpoint), body: jsonEncode(body));
    });

    dynamic json = jsonDecode(response?.body.toString() ?? "");
    if (json is Map<String, dynamic>) {
      if (json.containsKey('data')) json = useJapx ? Japx.decode(json) : json;
      return objectTransformer(json);
    }
  }

  Future<dynamic> create({
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
  }) async {
    String endpoint = objectNameUrlModel.createUrl(queryParameters: queryParameters);

    await _beforeExec(endpoint, () async {
      response = await network?.http?.post(Uri.parse(endpoint), body: jsonEncode(body));
    });

    dynamic json;
    try {
      json = jsonDecode(response?.body.toString() ?? "");
    } catch (e) {
      return null;
    }

    if (json is Map<String, dynamic>) {
      if (json.containsKey('data')) json = useJapx ? Japx.decode(json) : json;
      return objectTransformer(json);
    }
    return json;
  }

  Future<dynamic> delete({
    String? id,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic> body = const {},
  }) async {
    String endpoint = objectNameUrlModel.deletelUrl(id: id, queryParameters: queryParameters);

    await _beforeExec(endpoint, () async {
      response = await network?.http?.delete(Uri.parse(endpoint), body: jsonEncode(body));
    });

    dynamic json = jsonDecode(response?.body.toString() ?? "");
    if (json is Map<String, dynamic>) {
      if (json.containsKey('data')) json = useJapx ? Japx.decode(json) : json;
      return objectTransformer(json);
    }
    return json;
  }

  T objectTransformer(Map<String, dynamic> json);
  itemsTransformer(Map<String, dynamic> json) {}

  List<T>? buildItems(Map<String, dynamic> json) {
    if (json.containsKey('data') && json['data'] != null) {
      List data = json['data'];
      List<T> items = [];
      data.forEach((item) {
        Map<String, dynamic>? attrs = item;
        T record = objectTransformer(attrs ?? {});
        items.add(record);
      });
      return items;
    }
  }

  MetaModel? buildMeta(Map<String, dynamic> json) {
    if (json.containsKey('meta') && json['meta'] != null) {
      return MetaModel.fromJson(json['meta']);
    }
  }

  LinksModel? buildLinks(Map<String, dynamic> json) {
    if (json.containsKey('links') && json['links'] != null) {
      return LinksModel.fromJson(json['links']);
    }
  }

  Map<String, dynamic> sliceParams(Map<String, dynamic> values, List<String> names) {
    Map<String, dynamic> result = {};
    names.forEach((element) {
      result[element] = values[element];
    });
    return result;
  }

  Map<String, dynamic>? buildFetchAlQueryParameters(Map<String, dynamic>? queryParameters) {
    Map<String, dynamic> perPage = {"per_page": "10"};
    queryParameters ??= perPage;
    if (!queryParameters.containsKey('per_page')) {
      queryParameters.addAll(perPage);
    }
    queryParameters = AppHelper.filterOutNull(queryParameters);
    return queryParameters;
  }

  String get nameInUrl;
  String get baseUrl => ApiConstant.baseUrl;

  ObjectNameUrlModel get objectNameUrlModel {
    return ObjectNameUrlModel(nameInUrl: nameInUrl, path: "", baseUrl: baseUrl);
  }
}
