import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:flutter/material.dart';

class CgDropDownFieldItem {
  final String label;
  final dynamic value;

  CgDropDownFieldItem({
    required this.label,
    required this.value,
  });
}

class CgDropDownField extends StatefulWidget {
  const CgDropDownField({
    Key? key,
    this.fillColor,
    this.initValue,
    this.labelText,
    this.hintText,
    this.prefix,
    this.suffix,
    this.isExpanded = false,
    this.outlineBorder = false,
    this.onChanged,
    required this.items,
  }) : super(key: key);

  final Color? fillColor;
  final String? initValue;
  final String? labelText;
  final String? hintText;
  final Widget? suffix;
  final Widget? prefix;
  final bool isExpanded;
  final bool outlineBorder;
  final void Function(dynamic value)? onChanged;
  final List<CgDropDownFieldItem> items;

  @override
  _CgDropDownFieldState createState() => _CgDropDownFieldState();
}

class _CgDropDownFieldState extends State<CgDropDownField> with CgThemeMixin {
  String? currentValue;

  @override
  void initState() {
    currentValue = widget.initValue ?? widget.items.first.value;
    super.initState();
  }

  void setCurrentValue(String? value) {
    setState(() {
      currentValue = value;
    });

    if (widget.onChanged != null) {
      if (value == "null") {
        widget.onChanged!(null);
      } else {
        widget.onChanged!(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: currentValue,
      items: buildItems(),
      isExpanded: widget.isExpanded,
      decoration: buildInputDecoration(context),
      onChanged: (dynamic value) => setCurrentValue(value),
    );
  }

  List<DropdownMenuItem> buildItems() {
    return widget.items.map((e) {
      return DropdownMenuItem(
        child: Text(e.label),
        value: e.value == null ? "null" : e.value,
      );
    }).toList();
  }

  InputDecoration buildInputDecoration(BuildContext context) {
    return InputDecoration(
      labelText: widget.labelText,
      hintText: widget.hintText,
      fillColor: widget.fillColor ?? colorScheme.background,
      filled: true,
      labelStyle: Theme.of(context).textTheme.bodyText2,
      focusedBorder: widget.outlineBorder
          ? OutlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none)
          : UnderlineInputBorder(borderRadius: BorderRadius.circular(4.0), borderSide: BorderSide.none),
      border: widget.outlineBorder
          ? OutlineInputBorder(borderSide: BorderSide.none)
          : UnderlineInputBorder(borderSide: BorderSide.none),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      suffixIcon: widget.suffix,
      prefix: widget.prefix,
    );
  }
}
