import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:flutter/material.dart';

class CgBottomNavWrapper extends StatefulWidget {
  const CgBottomNavWrapper({
    Key? key,
    required this.child,
    this.visible = true,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final bool visible;
  final EdgeInsets? padding;

  @override
  _CgBottomNavWrapperState createState() => _CgBottomNavWrapperState();
}

class _CgBottomNavWrapperState extends State<CgBottomNavWrapper> with CgMediaQueryMixin, CgThemeMixin {
  @override
  Widget build(BuildContext context) {
    final bottomHeight = MediaQuery.of(context).viewPadding.bottom;
    final height = bottomHeight + ConfigConstant.margin2 + kBottomNavigationBarHeight;
    return Material(
      elevation: themeData.bottomNavigationBarTheme.elevation ?? 8.0,
      color: colorScheme.surface,
      child: IgnorePointer(
        ignoring: widget.visible == false,
        child: AnimatedOpacity(
          opacity: widget.visible ? 1 : 0,
          duration: ConfigConstant.fadeDuration,
          curve: Curves.ease,
          child: AnimatedContainer(
            duration: ConfigConstant.fadeDuration,
            padding: widget.padding ??
                EdgeInsets.symmetric(
                  horizontal: ConfigConstant.margin2,
                  vertical: ConfigConstant.margin1,
                ),
            transform: Matrix4.identity()..translate(0.0, widget.visible ? 0.0 : height),
            curve: Curves.ease,
            child: SafeArea(
              child: Wrap(
                children: [
                  widget.child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
