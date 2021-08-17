import 'package:after_layout/after_layout.dart';
import 'package:cambodia_geography/app_builder.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/configs/theme_config.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/models/apis/user_token_model.dart';
import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:cambodia_geography/screens/home/home_screen.dart';
import 'package:cambodia_geography/services/apis/users/user_api.dart';
import 'package:cambodia_geography/services/storages/locale_storage.dart';
import 'package:cambodia_geography/services/storages/theme_mode_storage.dart';
import 'package:cambodia_geography/services/storages/user_token_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

class _AppState extends State<App> with AfterLayoutMixin<App> {
  late bool isDarkMode;
  late Locale? locale;
  late ThemeModeStorage storage;
  late UserTokenStorage userTokenStorage;
  late LocaleStorage localeStorage;
  late UserTokenModel? _userToken;
  late String? initialRoute;
  late UserApi userApi;

  late ValueNotifier<UserModel?> userNotifier;

  @override
  void initState() {
    userApi = UserApi();
    storage = ThemeModeStorage();
    localeStorage = LocaleStorage();
    userTokenStorage = UserTokenStorage();
    userNotifier = ValueNotifier(null);
    isDarkMode = widget.initialIsDarkMode;
    locale = widget.initialLocale;
    initialRoute = widget.initialRoute;
    _userToken = widget.userToken;
    super.initState();
  }

  @override
  void dispose() {
    userNotifier.dispose();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    fetchCurrentUser();
  }

  Future<void> signOut() async {
    await userTokenStorage.remove();
    this.userNotifier.value = null;
    this._userToken = userNotifier.value = null;
  }

  Future<void> fetchCurrentUser() async {
    userNotifier.value = await userApi.fetchCurrentUser();
    print(userNotifier.value);
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
