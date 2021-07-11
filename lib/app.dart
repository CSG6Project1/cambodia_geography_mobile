import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/configs/theme_config.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/screens/home/home_screen.dart';
import 'package:cambodia_geography/services/storages/locale_storage.dart';
import 'package:cambodia_geography/services/storages/theme_mode_storage.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
    required this.initialIsDarkMode,
    required this.initialLocale,
  }) : super(key: key);

  final bool initialIsDarkMode;
  final Locale? initialLocale;

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

  @override
  void initState() {
    storage = ThemeModeStorage();
    localeStorage = LocaleStorage();
    isDarkMode = widget.initialIsDarkMode;
    locale = widget.initialLocale;
    super.initState();
  }

  void updateLocale(Locale _locale) {
    setState(() => this.locale = _locale);
    localeStorage.writeLocale(_locale);
  }

  void useDefaultLocale() {
    setState(() => this.locale = null);
    localeStorage.remove();
  }

  void turnDarkModeOn() {
    setState(() => isDarkMode = true);
    storage.writeBool(value: isDarkMode);
  }

  void turnDarkModeOff() {
    setState(() => isDarkMode = false);
    storage.writeBool(value: isDarkMode);
  }

  void toggleDarkMode() => isDarkMode ? turnDarkModeOff() : turnDarkModeOn();
  void setDarkMode(bool _isDarkMode) => !_isDarkMode ? turnDarkModeOff() : turnDarkModeOn();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeConfig(isDarkMode).themeData,
      home: HomeScreen(),
      initialRoute: RouteConfig.HOME,
      navigatorObservers: [HeroController()],
      onGenerateRoute: (setting) => RouteConfig(settings: setting).generate(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
