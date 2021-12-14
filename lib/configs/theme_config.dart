import 'package:cambodia_geography/constants/theme_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeConfig {
  final bool isDarkMode;
  ThemeConfig(this.isDarkMode);

  ThemeData get themeData {
    final scheme = isDarkMode ? ThemeConstant.darkScheme : ThemeConstant.lightScheme;
    return ThemeData(
      primaryColor: scheme.primary,
      backgroundColor: scheme.background,
      scaffoldBackgroundColor: scheme.background,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        centerTitle: false,
        elevation: 10.0,
        iconTheme: IconThemeData(color: scheme.onPrimary),
        titleTextStyle: ThemeConstant.textTheme.headline6?.copyWith(color: scheme.onPrimary),
        foregroundColor: scheme.onPrimary,
      ),
      // splashFactory:
      // InkRipple.splashFactory, //
      // InkSplash.splashFactory,
      indicatorColor: scheme.onPrimary,
      textTheme: ThemeConstant.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface.withOpacity(0.54),
        decorationColor: scheme.onSurface.withOpacity(0.54),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: scheme.primary,
          onSurface: scheme.onSurface,
          primary: scheme.onPrimary,
        ),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(),
      ),
    );
  }
}
