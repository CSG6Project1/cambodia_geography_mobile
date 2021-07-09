import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/theme_config.dart';
import 'package:cambodia_geography/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CambodiaGeography.instance.initilize();

  runApp(
    MaterialApp(
      home: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeConfig().themeData,
      home: HomeScreen(),
      navigatorObservers: [HeroController()],
    );
  }
}
