import 'package:after_layout/after_layout.dart';
import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/cg_page_route.dart';
import 'package:cambodia_geography/constants/theme_constant.dart';
import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:cambodia_geography/services/storages/init_app_state_storage.dart';
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

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin<SplashScreen> {
  @override
  void afterFirstLayout(BuildContext context) {
    _initializeApp().then(_goToNextPage);
  }

  void _goToNextPage(_IntModel value) {
    Navigator.of(context).push(
      CgPageRoute.fadeThrough(
        (context, animation, secondaryAnimation) => App(
          initialIsDarkMode: value.isDarkMode == true,
          initialLocale: value.locale,
          userToken: value.userToken,
          initialRoute: value.route,
        ),
      ),
    );
  }

  Future<_IntModel> _initializeApp() async {
    await Firebase.initializeApp();
    await CambodiaGeography.instance.initilize();

    bool isDarkMode = await _getInitialDarkMode();
    Locale? locale = await _getInitialLocale();
    UserTokenModel? userToken = await _getInitalUserToken();

    String route = await InitAppStateStorage().getInitialRouteName();
    return _IntModel(isDarkMode, locale, userToken, route);
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

class _IntModel {
  final bool? isDarkMode;
  final Locale? locale;
  final UserTokenModel? userToken;
  final String route;

  _IntModel(
    this.isDarkMode,
    this.locale,
    this.userToken,
    this.route,
  );
}
