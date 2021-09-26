import 'package:cambodia_geography/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // SharedPreferences.setMockInitialValues({});
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('km')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: TranslationWrapper(),
    ),
  );
}

class TranslationWrapper extends StatelessWidget {
  const TranslationWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: SplashScreen(),
    );
  }
}
