import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:cambodia_geography/services/storages/theme_mode_storage.dart';
import 'package:cambodia_geography/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'models/apis/user_token_model.dart';

void main() async {
  // SharedPreferences.setMockInitialValues({});
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  );
}

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
