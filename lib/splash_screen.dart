import 'package:after_layout/after_layout.dart';
import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/provider_scope.dart';
import 'package:cambodia_geography/configs/cg_page_route.dart';
import 'package:cambodia_geography/constants/theme_constant.dart';
import 'package:cambodia_geography/services/storages/init_app_state_storage.dart';
import 'package:cambodia_geography/utils/initialize_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/apis/user_token_model.dart';

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

  Future<_IntModel> _initializeApp() async {
    await Firebase.initializeApp();
    await CambodiaGeography.instance.initilize();

    bool isDarkMode = await getInitialDarkMode();
    Locale? locale = await getInitialLocale();
    UserTokenModel? userToken = await getInitalUserToken();

    String route = await InitAppStateStorage().getInitialRouteName();
    return _IntModel(isDarkMode, locale, userToken, route);
  }

  void _goToNextPage(_IntModel value) {
    Navigator.of(context).pushReplacement(
      CgPageRoute.fadeThrough(
        builder: (context) => ProviderScope(
          initialIsDarkMode: value.isDarkMode == true,
          initialLocale: value.locale,
          userToken: value.userToken,
          initialRoute: value.route,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TweenAnimationBuilder<int>(
        duration: ConfigConstant.fadeDuration,
        tween: IntTween(begin: 0, end: 100),
        builder: (context, opacity, child) {
          return Opacity(
            opacity: opacity / 100,
            child: Center(
              child: CircularProgressIndicator(
                color: ThemeConstant.lightScheme.primary,
              ),
            ),
          );
        },
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
