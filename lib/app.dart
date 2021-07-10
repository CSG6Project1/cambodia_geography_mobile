import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/configs/theme_config.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/screens/district/district_screen.dart';
import 'package:cambodia_geography/screens/home/home_screen.dart';
import 'package:cambodia_geography/services/storages/theme_mode_storage.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
    required this.initialIsDarkMode,
  }) : super(key: key);

  final bool initialIsDarkMode;

  static _AppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>();
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late bool isDarkMode;
  late ThemeModeStorage storage;

  @override
  void initState() {
    super.initState();
    storage = ThemeModeStorage();
    isDarkMode = widget.initialIsDarkMode;
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
      navigatorObservers: [HeroController()],
      onGenerateRoute: (settings) {
        if (settings.name == RouteConfig.DISTRICT) {
          final district = settings.arguments as TbDistrictModel;
          return SwipeablePageRoute(
            builder: (BuildContext context) => DistrictScreen(district: district),
          );
        }
      },
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
