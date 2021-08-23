import 'dart:convert';
import 'dart:io';
import 'package:cambodia_geography/constants/api_constant.dart';
import 'package:cambodia_geography/models/apis/user_token_model.dart';
import 'package:cambodia_geography/services/networks/base_network.dart';
import 'package:cambodia_geography/services/storages/user_token_storage.dart';
import 'package:http/http.dart';

class AuthApi {
  Response? response;
  BaseNetwork? network;
  late UserTokenStorage storage;

  AuthApi() {
    network = BaseNetwork();
    storage = UserTokenStorage();
  }

  bool success() {
    if (this.response == null) return false;
    return this.response!.statusCode == 200;
  }

  String? errorMessage() {
    if (response?.body == null) return null;
    var json = jsonDecode(response!.body);
    if (json is Map && json.containsKey('message')) {
      return json['message'];
    }
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

  Future<void> saveToStorage(Map<String, dynamic> data) async {
    await storage.writeMap(data);
  }

  Future<void> loginWithSocialAccount({required String idToken}) async {
    return _beforeExec(() async {
      var body = {
        "id_token": idToken,
        "grant_type": "credential",
      };

      Uri endpoint = Uri.parse(authPath);
      response = await this.network?.http?.post(endpoint, body: jsonEncode(body));

      if (success() && response?.body != null) {
        var json = jsonDecode(response!.body);
        saveToStorage(json);
      }
    });
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return _beforeExec(() async {
      var body = {
        "email": email,
        "password": password,
        "grant_type": "password",
      };

      Uri endpoint = Uri.parse(authPath);
      response = await this.network?.http?.post(endpoint, body: jsonEncode(body));

      if (success() && response?.body != null) {
        var json = jsonDecode(response!.body);
        saveToStorage(json);
      }
    });
  }

  Future<UserTokenModel?> getCurrentUserToken() async {
    var json = await this.storage.readMap();
    if (json != null) {
      var validated = Map.fromIterable(json.entries, key: (e) => "${e.key}", value: (e) => e.value);
      return UserTokenModel.fromJson(validated);
    }
  }

  Future<void> reAuthenticate({required String refreshToken}) async {
    return _beforeExec(() async {
      Map<String, String> body = {
        "grant_type": "refresh_token",
        "refresh_token": refreshToken,
      };
      Uri endpoint = Uri.parse(authPath);
      response = await this.network?.http?.post(endpoint, body: jsonEncode(body));

      if (success() && response?.body != null) {
        var json = jsonDecode(response!.body);
        saveToStorage(json);
      }
    });
  }

  String get authPath => ApiConstant.authPath;
}
