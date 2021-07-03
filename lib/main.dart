import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/home_screen.dart';
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
      theme: ThemeData(
        primaryColor: Color(0xFFCE2B30),
      ),
      home: HomeScreen(geo: geo),
    );
  }
}
