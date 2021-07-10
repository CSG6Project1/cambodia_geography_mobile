import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:flutter/material.dart';

class CgTextField extends StatefulWidget {
  const CgTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  final String? labelText;
  final String? hintText;
  final Widget? suffix;
  final Widget? prefix;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;

  @override
  _CgTextFieldState createState() => _CgTextFieldState();
}

class _CgTextFieldState extends State<CgTextField> with CgThemeMixin {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      decoration: buildInputDecoration(colorScheme),
    );
  }

  InputDecoration buildInputDecoration(ColorScheme colorScheme) {
    return InputDecoration(
      labelText: widget.labelText,
      hintText: widget.hintText,
      fillColor: colorScheme.background,
      filled: true,
      labelStyle: Theme.of(context).textTheme.bodyText2,
      focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none),
      border: UnderlineInputBorder(borderSide: BorderSide.none),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      suffixIcon: widget.suffix,
      prefix: widget.prefix,
    );
  }
}
