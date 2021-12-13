import 'package:cambodia_geography/models/apis/user_token_model.dart';
import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:cambodia_geography/services/storages/locale_storage.dart';
import 'package:cambodia_geography/services/storages/theme_mode_storage.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

Future<UserTokenModel?> getInitalUserToken() async {
  try {
    AuthApi authApi = AuthApi();
    UserTokenModel? userToken = await authApi.getCurrentUserToken();
    return userToken;
  } catch (e) {}
}

Future<bool> getInitialDarkMode() async {
  ThemeModeStorage storage = ThemeModeStorage();
  bool? isDarkMode;
  try {
    isDarkMode = await storage.readBool();
  } catch (e) {}
  if (isDarkMode == null) {
    Brightness? platformBrightness = SchedulerBinding.instance?.window.platformBrightness;
    isDarkMode = platformBrightness == Brightness.dark;
  }
  return isDarkMode;
}

Future<Locale?> getInitialLocale() async {
  LocaleStorage storage = LocaleStorage();
  Locale? locale;
  try {
    locale = await storage.readLocale();
  } catch (e) {}
  return locale;
}

void initialRemoteConfig() async {
  try {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.setDefaults(<String, dynamic>{
      'enable_facebook_auth': false,
    });
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 5),
      minimumFetchInterval: const Duration(hours: 12),
    ));
    remoteConfig.fetchAndActivate().then((value) => print(value));
  } catch (e) {
    print("ERROR: $e");
  }
}
