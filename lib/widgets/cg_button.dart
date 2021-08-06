import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/helpers/app_helper.dart';
import 'package:cambodia_geography/helpers/color_helper.dart';
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
    this.showBorder = false,
    this.width,
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
  final bool showBorder;
  final double? width;

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (iconData != null) {
      child = TextButton.icon(
        icon: buildIcon(),
        style: buildButtonStyle(context),
        label: buildLabel(context),
        onPressed: onPressed,
        onLongPress: onLongPress,
        clipBehavior: clipBehavior,
        autofocus: autofocus,
        focusNode: focusNode,
      );
    } else {
      child = TextButton(
        style: buildButtonStyle(context),
        child: buildLabel(context),
        onPressed: onPressed,
        onLongPress: onLongPress,
        clipBehavior: clipBehavior,
        autofocus: autofocus,
        focusNode: focusNode,
      );
    }

    return Container(
      width: width,
      child: child,
    );
  }

  Widget buildIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: ConfigConstant.margin1),
      child: Icon(iconData, size: iconSize, color: foregroundColor),
    );
  }

  Widget buildLabel(BuildContext context) {
    return Padding(
      padding: iconData != null
          ? const EdgeInsets.only(right: ConfigConstant.margin1)
          : const EdgeInsets.symmetric(horizontal: ConfigConstant.margin1),
      child: Text(
        labelText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: onPressed == null ? Theme.of(context).colorScheme.onBackground : foregroundColor),
      ),
    );
  }

  ButtonStyle buildButtonStyle(BuildContext context) {
    Color? overlayColor;
    if (backgroundColor != null) {
      bool lightBackground = ColorHelper.textColorForBackground(backgroundColor!) == Colors.black;
      if (lightBackground) {
        overlayColor = ColorHelper.darken(backgroundColor!);
      }
    }
    return TextButton.styleFrom(
      backgroundColor: onPressed == null ? Theme.of(context).colorScheme.background : backgroundColor,
    ).copyWith(
      overlayColor: MaterialStateProperty.all<Color?>(overlayColor),
      side: MaterialStateProperty.all<BorderSide>(
        showBorder && foregroundColor != null ? BorderSide(color: foregroundColor!) : BorderSide.none,
      ),
    );
  }
}
