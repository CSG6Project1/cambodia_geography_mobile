import 'package:cambodia_geography/constants/theme_constant.dart';
import 'package:cambodia_geography/splash_screen.dart';
import 'package:cambodia_geography/utils/initialize_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  timeago.setLocaleMessages('km', timeago.KmMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());

  initialRemoteConfig();

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
    return buildWrapper(
      context: context,
      child: SplashScreen(),
    );
  }

  Widget buildWrapper({required BuildContext context, required Widget child}) {
    // not main MaterialApp.
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: child,
      theme: ThemeData.light().copyWith(colorScheme: ThemeConstant.lightScheme),
    );
  }
}
