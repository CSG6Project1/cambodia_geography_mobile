import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:flutter/material.dart';

class CgDropDownField extends StatefulWidget {
  const CgDropDownField({
    Key? key,
    this.initValue,
    this.labelText,
    this.hintText,
    this.prefix,
    this.suffix,
    this.onChanged,
    required this.items,
  }) : super(key: key);

  final List<String> items;
  final String? initValue;
  final String? labelText;
  final String? hintText;
  final Widget? suffix;
  final Widget? prefix;
  final void Function(String? value)? onChanged;

  @override
  _CgDropDownFieldState createState() => _CgDropDownFieldState();
}

class _CgDropDownFieldState extends State<CgDropDownField> with CgThemeMixin {
  String? currentValue;

  @override
  void initState() {
    currentValue = widget.initValue ?? widget.items.first;
    super.initState();
  }

  void setCurrentValue(String? value) {
    setState(() {
      currentValue = value;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: currentValue,
      items: buildItems(),
      decoration: buildInputDecoration(context),
      onChanged: (String? value) => setCurrentValue(value),
    );
  }

  List<DropdownMenuItem<String>> buildItems() {
    return widget.items.map((String value) {
      return DropdownMenuItem(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  InputDecoration buildInputDecoration(BuildContext context) {
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
