import 'package:flutter/material.dart';

class CgButton extends StatelessWidget {
  const CgButton({
    Key? key,
    required this.labelText,
    this.backgroundColor,
    this.foregroundColor,
    this.onPressed,
    this.onLongPress,
    this.clipBehavior = Clip.none,
    this.autofocus = false,
    this.focusNode,
    this.iconSize = 20,
    this.iconData,
  }) : super(key: key);

  final String labelText;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Clip clipBehavior;
  final void Function()? onLongPress;
  final void Function()? onPressed;
  final FocusNode? focusNode;
  final bool autofocus;
  final IconData? iconData;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    if (iconData != null) {
      return TextButton.icon(
        icon: Icon(iconData, size: iconSize),
        style: buildButtonStyle(context),
        label: Text(labelText),
        onPressed: onPressed,
        onLongPress: onLongPress,
        clipBehavior: clipBehavior,
        autofocus: autofocus,
        focusNode: focusNode,
      );
    }
    return TextButton(
      style: buildButtonStyle(context),
      child: Text(labelText),
      onPressed: onPressed,
      onLongPress: onLongPress,
      clipBehavior: clipBehavior,
      autofocus: autofocus,
      focusNode: focusNode,
    );
  }

  ButtonStyle buildButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      backgroundColor: onPressed == null ? Theme.of(context).colorScheme.background : backgroundColor,
    );
  }
}
