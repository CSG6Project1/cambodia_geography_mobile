import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final geo = CambodiaGeography();
  await geo.initilize();
  final list = geo.villagesSearch(communeCode: "080412");
  print(list);

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
    return Scaffold();
  }
}
