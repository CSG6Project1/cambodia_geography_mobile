import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:cambodia_geography/splash_screen.dart';
import 'package:flutter/material.dart';
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
