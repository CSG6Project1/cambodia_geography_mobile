import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/theme_config.dart';
import 'package:cambodia_geography/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final geo = CambodiaGeography();
  await geo.initilize();

  runApp(
    MaterialApp(
      home: App(geo: geo),
    ),
  );
}

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.geo,
  }) : super(key: key);

  final CambodiaGeography geo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeConfig().themeData,
      home: HomeScreen(geo: geo),
      navigatorObservers: [HeroController()],
    );
  }
}
