import 'package:flutter/material.dart';

class ThemeConstant {
  static const List<String> fontFamilyFallback = ["Battambang", "Lora"];

  static const TextTheme textTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 98,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
      fontFamilyFallback: fontFamilyFallback,
    ),
    headline2: TextStyle(
      fontSize: 61,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      fontFamilyFallback: fontFamilyFallback,
    ),
    headline3: TextStyle(
      fontSize: 49,
      fontWeight: FontWeight.w400,
      fontFamilyFallback: fontFamilyFallback,
    ),
    headline4: TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamilyFallback: fontFamilyFallback,
    ),
    headline5: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      fontFamilyFallback: fontFamilyFallback,
    ),
    headline6: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      fontFamilyFallback: fontFamilyFallback,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      fontFamilyFallback: fontFamilyFallback,
    ),
    subtitle2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      fontFamilyFallback: fontFamilyFallback,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      fontFamilyFallback: fontFamilyFallback,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      fontFamilyFallback: fontFamilyFallback,
    ),
    button: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
      fontFamilyFallback: fontFamilyFallback,
    ),
    caption: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      fontFamilyFallback: fontFamilyFallback,
    ),
    overline: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      fontFamilyFallback: fontFamilyFallback,
    ),
  );
}
