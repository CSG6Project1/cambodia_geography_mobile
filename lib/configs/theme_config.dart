import 'package:cambodia_geography/constants/theme_constant.dart';
import 'package:flutter/material.dart';

class ThemeConfig {
  ThemeData get themeData {
    return ThemeData(
      primaryColor: Color(0xFFCE2B30),
      backgroundColor: Color(0xFFF8F8F8),
      appBarTheme: AppBarTheme(backgroundColor: Color(0xFFCE2B30), elevation: 10),
      indicatorColor: Colors.white,
      textTheme: ThemeConstant.textTheme
          .apply(bodyColor: Colors.black, displayColor: Colors.black54, decorationColor: Colors.black54),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Color(0xFFCE2B30),
          onSurface: Colors.white,
          primary: Colors.white,
        ),
      ),
    );
  }
}
