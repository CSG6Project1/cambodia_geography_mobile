import 'package:flutter/material.dart';

class CGAppBarTitle extends StatelessWidget {
  const CGAppBarTitle({
    Key? key,
    this.textStyle,
    required this.title,
  }) : super(key: key);

  final String title;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      key: Key(title),
      style: Theme.of(context).appBarTheme.titleTextStyle ?? textStyle,
    );
  }
}
