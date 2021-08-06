import 'dart:ui';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/screens/drawer/app_drawer.dart';
import 'package:flutter/material.dart';

class DrawerWrapper extends StatefulWidget {
  final Widget child;
  final BuildContext context;

  const DrawerWrapper({
    Key? key,
    required this.child,
    required this.context,
  }) : super(key: key);

  static _DrawerWrapperState? of(BuildContext context) {
    return context.findAncestorStateOfType<_DrawerWrapperState>();
  }

  @override
  _DrawerWrapperState createState() => _DrawerWrapperState();
}

class _DrawerWrapperState extends State<DrawerWrapper>
    with SingleTickerProviderStateMixin, CgThemeMixin, CgMediaQueryMixin {
  late double _maxSlide;
  late double _minDragStartEdge;
  late double _maxDragStartEdge;

  late AnimationController animationController;
  late ValueNotifier _notifier;

  bool _canBeDragged = false;

  @override
  void initState() {
    _notifier = ValueNotifier<double>(0);
    animationController = AnimationController(duration: ConfigConstant.fadeDuration, vsync: this);
    _maxSlide = MediaQuery.of(widget.context).size.width - kToolbarHeight;
    _minDragStartEdge = _maxSlide;
    _maxDragStartEdge = _maxSlide;
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    _notifier.dispose();
    super.dispose();
  }

  Future<void> close() async => await animationController.reverse();
  Future<void> open() async => await animationController.forward();
  Future<void> toggleDrawer() async => animationController.isCompleted ? await close() : await open();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (animationController.isCompleted) {
          close();
          return false;
        }
        return true;
      },
      child: Container(
        color: Colors.white,
        child: GestureDetector(
          onHorizontalDragStart: _onDragStart,
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: _onDragEnd,
          child: Stack(
            children: [
              buildChild(),
              buildDrawer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return AnimatedBuilder(
      animation: animationController,
      child: AppDrawer(),
      builder: (context, child) {
        CurveTween curve = CurveTween(curve: Curves.ease);
        double animValue = animationController.drive(curve).value;
        final slideAmount = _maxSlide * animValue;
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          _notifier.value = slideAmount;
        });

        return Container(
          transform: Matrix4.identity()..translate(slideAmount - _maxSlide),
          alignment: Alignment.centerLeft,
          child: child,
        );
      },
    );
  }

  Widget buildChild() {
    return ValueListenableBuilder(
      valueListenable: _notifier,
      child: buildChildOverlay(),
      builder: (context, value, child) {
        return AnimatedContainer(
          curve: Curves.ease,
          duration: const Duration(milliseconds: 0),
          transform: Matrix4.identity()..translate(_notifier.value),
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: animationController.isCompleted ? close : null,
            child: child,
          ),
        );
      },
    );
  }

  Widget buildChildOverlay() {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            double opacity = lerpDouble(0, 0.5, animationController.value) ?? 0;
            double shadowOpacity = lerpDouble(0.0, 0.25, animationController.value) ?? 0;
            return IgnorePointer(
              ignoring: animationController.isDismissed,
              child: AnimatedContainer(
                width: double.infinity,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(opacity),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(4 - MediaQuery.of(context).size.width, 0.0),
                      blurRadius: 12.0,
                      color: Theme.of(context).shadowColor.withOpacity(shadowOpacity),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed && details.globalPosition.dx < _minDragStartEdge;
    bool isDragCloseFromRight = animationController.isCompleted && details.globalPosition.dx > _maxDragStartEdge;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_canBeDragged) return;
    double delta = (details.primaryDelta ?? 0) / _maxSlide;
    animationController.value += delta;
  }

  void _onDragEnd(DragEndDetails details) {
    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }

    double _kMinFlingVelocity = 365.0;
    double _width = MediaQuery.of(context).size.width;

    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / _width;
      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      close();
    } else {
      open();
    }
  }
}
