import 'package:flutter/material.dart';

mixin CgThemeMixin<T extends StatefulWidget> on State<T> {
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  TextTheme get textTheme => Theme.of(context).textTheme;
  ThemeData get themeData => Theme.of(context);
}
