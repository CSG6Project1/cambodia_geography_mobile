import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:flutter/material.dart';

class CgTextField extends StatefulWidget {
  const CgTextField({
    Key? key,
    this.controller,
    this.value,
    this.labelText,
    this.hintText,
    this.prefix,
    this.suffix,
    this.fillColor,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.autocorrect = true,
    this.keyboardType,
    this.textInputAction,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? value;
  final String? labelText;
  final String? hintText;
  final Widget? suffix;
  final Widget? prefix;
  final Color? fillColor;
  final bool obscureText;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  _CgTextFieldState createState() => _CgTextFieldState();
}

class _CgTextFieldState extends State<CgTextField> with CgThemeMixin {
  late TextEditingController controller;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController(text: widget.value ?? "");
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller != null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardAppearance: colorScheme.brightness,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      controller: controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      autocorrect: widget.autocorrect,
      obscureText: widget.obscureText,
      decoration: buildInputDecoration(colorScheme),
    );
  }

  InputDecoration buildInputDecoration(ColorScheme colorScheme) {
    return InputDecoration(
      labelText: widget.labelText,
      hintText: widget.hintText,
      fillColor: widget.fillColor ?? colorScheme.background,
      filled: true,
      labelStyle: Theme.of(context).textTheme.bodyText2,
      border: UnderlineInputBorder(
        borderRadius: ConfigConstant.circlarRadiusTop1,
        borderSide: BorderSide(color: colorScheme.primary),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      suffixIcon: widget.suffix,
      prefix: widget.prefix,
    );
  }
}
