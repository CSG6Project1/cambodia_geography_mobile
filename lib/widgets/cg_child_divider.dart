import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:flutter/material.dart';

class CgChildDivider extends StatelessWidget {
  const CgChildDivider({
    Key? key,
    required this.child,
    this.dividerColor,
  }) : super(key: key);

  final Widget child;
  final Color? dividerColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor,
            height: 0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
          child: child,
        ),
        Expanded(
          child: Divider(
            color: dividerColor,
            height: 0,
          ),
        ),
      ],
    );
  }
}
