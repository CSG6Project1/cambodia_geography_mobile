import 'package:flutter/material.dart';

class CgHeadlineText extends StatelessWidget {
  const CgHeadlineText(
    this.text, {
    Key? key,
    this.textAlign,
    this.color,
  }) : super(key: key);

  final String text;
  final TextAlign? textAlign;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context)
          .textTheme
          .headline6
          ?.copyWith(fontWeight: FontWeight.w600, color: color ?? Theme.of(context).colorScheme.onPrimary),
    );
  }
}
