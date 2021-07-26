import 'package:flutter/material.dart';

class CgOnTapEffect extends StatelessWidget {
  const CgOnTapEffect({
    required this.child,
    required this.onTap,
    this.splashColor,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final void Function()? onTap;
  final Color? splashColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: splashColor ?? Theme.of(context).colorScheme.surface.withOpacity(0.05),
            ),
          ),
        )
      ],
    );
  }
}
