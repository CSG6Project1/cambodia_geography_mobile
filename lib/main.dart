import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/services/storages/locale_storage.dart';
import 'package:cambodia_geography/services/storages/theme_mode_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CambodiaGeography.instance.initilize();
  bool isDarkMode = await getInitialDarkMode();
  Locale? locale = await getInitialLocale();

  runApp(
    App(
      initialIsDarkMode: isDarkMode,
      initialLocale: locale,
    ),
  );
}

Future<Locale?> getInitialLocale() async {
  LocaleStorage storage = LocaleStorage();
  Locale? locale = await storage.readLocale();
  return locale;
}

Future<bool> getInitialDarkMode() async {
  ThemeModeStorage storage = ThemeModeStorage();
  bool? isDarkMode = await storage.readBool();
  if (isDarkMode == null) {
    Brightness? platformBrightness = SchedulerBinding.instance?.window.platformBrightness;
    isDarkMode = platformBrightness == Brightness.dark;
  }
  return isDarkMode;
}
