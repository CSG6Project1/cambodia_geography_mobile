import 'dart:io';
import 'package:cambodia_geography/app_builder.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/configs/theme_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/providers/locale_provider.dart';
import 'package:cambodia_geography/providers/theme_provider.dart';
import 'package:cambodia_geography/screens/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
    required this.initialRoute,
  }) : super(key: key);

  final String? initialRoute;

  static _AppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>();
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with CgMediaQueryMixin, CgThemeMixin {
  ThemeProvider? themeProvider;
  LocaleProvider? localeProvider;
  bool _loading = false;

  Future<T?> showLoading<T>({void Function()? onCancel}) {
    if (!kIsWeb && Platform.isIOS) {
      return showCupertinoDialog<T>(
        context: context,
        builder: _loadingBuilder,
        barrierDismissible: false,
      );
    } else {
      return showDialog<T>(
        context: context,
        barrierDismissible: false,
        builder: _loadingBuilder,
      );
    }
  }

  void hideLoading() {
    if (_loading) {
      return Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    localeProvider = Provider.of<LocaleProvider>(context, listen: true);
    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: RouteConfig().routes[widget.initialRoute]?.screen ?? HomeScreen(),
      navigatorObservers: [HeroController()],
      onGenerateRoute: (setting) => RouteConfig(settings: setting).generate(),
      locale: localeProvider?.locale,
      builder: (context, child) => AppBuilder(child: child),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }

  Widget _loadingBuilder(BuildContext _context) {
    _loading = true;
    return Theme(
      data: theme,
      child: WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: LottieBuilder.asset(
            'assets/lotties/1055-world-locations.json',
            width: ConfigConstant.objectHeight6,
            height: ConfigConstant.objectHeight6,
          ),
        ),
      ),
    );
  }

  ThemeData get theme {
    return ThemeConfig(themeProvider?.isDarkMode == true).themeData;
  }
}
