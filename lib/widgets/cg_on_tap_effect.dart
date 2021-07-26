import 'package:flutter/material.dart';

class CgOnTapEffect extends StatelessWidget {
  const CgOnTapEffect({
    required this.child,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final void Function()? onTap;

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
            ),
          ),
        )
      ],
    );
  }
}
