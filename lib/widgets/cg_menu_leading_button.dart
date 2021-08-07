import 'dart:io';

import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/screens/drawer/drawer_wrapper.dart';

class CgMenuLeadingButton extends StatelessWidget {
  const CgMenuLeadingButton({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: animationController,
        ),
        onPressed: () {
          DrawerWrapper.of(context)?.open();
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          DrawerWrapper.of(context)?.open();
        },
      );
    }
  }
}
