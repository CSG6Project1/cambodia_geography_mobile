import 'package:cambodia_geography/app_builder.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/configs/theme_config.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/providers/locale_provider.dart';
import 'package:cambodia_geography/providers/theme_provider.dart';
import 'package:cambodia_geography/screens/home/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.initialRoute,
  }) : super(key: key);

  final String? initialRoute;

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    LocaleProvider localeProvider = Provider.of<LocaleProvider>(context, listen: true);
    return MaterialApp(
      theme: ThemeConfig(themeProvider.isDarkMode).themeData,
      debugShowCheckedModeBanner: false,
      home: RouteConfig().routes[initialRoute]?.screen ?? HomeScreen(),
      navigatorObservers: [HeroController()],
      onGenerateRoute: (setting) => RouteConfig(settings: setting).generate(),
      locale: localeProvider.locale,
      builder: (context, child) => AppBuilder(child: child),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
