import 'package:flutter/material.dart';

class CgAppBarTitle extends StatelessWidget {
  const CgAppBarTitle({
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
      style: textStyle?? Theme.of(context).appBarTheme.titleTextStyle,
    );
  }
}
