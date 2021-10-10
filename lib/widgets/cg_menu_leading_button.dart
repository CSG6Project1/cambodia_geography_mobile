import 'dart:io';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:flutter/foundation.dart';

class CgMenuLeadingButton extends StatelessWidget {
  const CgMenuLeadingButton({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && Platform.isAndroid) {
      return IconButton(
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: animationController,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.menu),
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    }
  }
}
