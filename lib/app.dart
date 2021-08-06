import 'package:cambodia_geography/app_builder.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/configs/theme_config.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/models/apis/user_token_model.dart';
import 'package:cambodia_geography/screens/home/home_screen.dart';
import 'package:cambodia_geography/services/storages/locale_storage.dart';
import 'package:cambodia_geography/services/storages/theme_mode_storage.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
    required this.initialIsDarkMode,
    required this.initialLocale,
    required this.userToken,
    required this.initialRoute,
  }) : super(key: key);

  final bool initialIsDarkMode;
  final Locale? initialLocale;
  final UserTokenModel? userToken;
  final String initialRoute;

  static _AppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>();
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late bool isDarkMode;
  late Locale? locale;
  late ThemeModeStorage storage;
  late LocaleStorage localeStorage;
  late UserTokenModel? _userToken;
  late String? initialRoute;

  @override
  void initState() {
    storage = ThemeModeStorage();
    localeStorage = LocaleStorage();
    isDarkMode = widget.initialIsDarkMode;
    locale = widget.initialLocale;
    initialRoute = widget.initialRoute;
    _userToken = widget.userToken;
    super.initState();
  }

  Future<void> updateLocale(Locale _locale) async {
    setState(() => this.locale = _locale);
    await localeStorage.writeLocale(_locale);
  }

  Future<void> useDefaultLocale() async {
    setState(() => this.locale = null);
    await localeStorage.remove();
  }

  Future<void> turnDarkModeOn() async {
    setState(() => isDarkMode = true);
    await storage.writeBool(value: isDarkMode);
  }

  Future<void> turnDarkModeOff() async {
    setState(() => isDarkMode = false);
    await storage.writeBool(value: isDarkMode);
  }

  Future<void> toggleDarkMode() => isDarkMode ? turnDarkModeOff() : turnDarkModeOn();
  Future<void> setDarkMode(bool _isDarkMode) => !_isDarkMode ? turnDarkModeOff() : turnDarkModeOn();

  bool get isSignedIn => this._userToken?.accessToken != null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeConfig(isDarkMode).themeData,
      debugShowCheckedModeBanner: false,
      home: RouteConfig().routes[initialRoute]?.screen ?? HomeScreen(),
      navigatorObservers: [HeroController()],
      onGenerateRoute: (setting) => RouteConfig(settings: setting).generate(),
      locale: locale,
      builder: (context, child) => AppBuilder(child: child),
    );
  }
}
