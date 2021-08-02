import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/theme_constant.dart';
import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:cambodia_geography/services/storages/locale_storage.dart';
import 'package:cambodia_geography/services/storages/theme_mode_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/apis/user_token_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: SplashScreen(),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp().then(_goToNextPage);
  }

  void _goToNextPage(_IntModel value) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => App(
          initialIsDarkMode: value.isDarkMode == true,
          initialLocale: value.locale,
          userToken: value.userToken,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: ThemeConstant.lightScheme.primary,
        ),
      ),
    );
  }
}

Future<_IntModel> _initializeApp() async {
  await Firebase.initializeApp();
  await CambodiaGeography.instance.initilize();

  bool isDarkMode = await _getInitialDarkMode();
  Locale? locale = await _getInitialLocale();
  UserTokenModel? userToken = await _getInitalUserToken();

  return _IntModel(isDarkMode, locale, userToken);
}

Future<UserTokenModel?> _getInitalUserToken() async {
  AuthApi authApi = AuthApi();
  UserTokenModel? userToken = await authApi.getCurrentUserToken();
  return userToken;
}

Future<Locale?> _getInitialLocale() async {
  LocaleStorage storage = LocaleStorage();
  Locale? locale = await storage.readLocale();
  return locale;
}

Future<bool> _getInitialDarkMode() async {
  ThemeModeStorage storage = ThemeModeStorage();
  bool? isDarkMode = await storage.readBool();
  if (isDarkMode == null) {
    Brightness? platformBrightness = SchedulerBinding.instance?.window.platformBrightness;
    isDarkMode = platformBrightness == Brightness.dark;
  }
  return isDarkMode;
}

class _IntModel {
  final bool? isDarkMode;
  final Locale? locale;
  final UserTokenModel? userToken;

  _IntModel(
    this.isDarkMode,
    this.locale,
    this.userToken,
  );
}
