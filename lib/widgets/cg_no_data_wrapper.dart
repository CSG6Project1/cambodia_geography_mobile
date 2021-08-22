import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:flutter/material.dart';

class CgNoDataWrapper extends StatelessWidget {
  const CgNoDataWrapper({
    Key? key,
    required this.child,
    required this.isNoData,
  }) : super(key: key);

  final Widget child;
  final bool isNoData;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Stack(
          children: [
            Positioned.fill(child: child),
            buildNoData(context: context, height: constraint.maxHeight, isNoData: isNoData),
          ],
        );
      },
    );
  }

  Widget buildNoData({
    required BuildContext context,
    required double height,
    required bool isNoData,
  }) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      left: 0,
      child: IgnorePointer(
        ignoring: !isNoData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: AnimatedOpacity(
            duration: ConfigConstant.duration,
            opacity: isNoData ? 1 : 0,
            child: Container(
              height: height,
              color: colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: ConfigConstant.iconSize5,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: ConfigConstant.margin1),
                  Text("មិនមានទិន្នន័យ"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
