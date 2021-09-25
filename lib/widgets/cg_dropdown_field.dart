import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:flutter/material.dart';

class CgDropDownFieldItem<T> {
  final String label;
  final T value;

  CgDropDownFieldItem({
    required this.label,
    required this.value,
  });
}

class CgDropDownField<T> extends StatefulWidget {
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
  final void Function(T? value)? onChanged;
  final List<CgDropDownFieldItem<T>> items;

  @override
  _CgDropDownFieldState<T> createState() => _CgDropDownFieldState<T>();
}

class _CgDropDownFieldState<T> extends State<CgDropDownField> with CgThemeMixin {
  T? currentValue;

  @override
  void initState() {
    currentValue = widget.initValue ?? widget.items.first.value;
    super.initState();
  }

  void setCurrentValue(T? value) {
    setState(() {
      currentValue = value;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: currentValue,
      items: buildItems(),
      isExpanded: widget.isExpanded,
      decoration: buildInputDecoration(context),
      onChanged: (T? value) => setCurrentValue(value),
    );
  }

  List<DropdownMenuItem<T>> buildItems() {
    return widget.items.map((e) {
      return DropdownMenuItem(
        child: Text(e.label),
        value: e.value as T,
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
