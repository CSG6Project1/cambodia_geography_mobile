import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class CgPageRoute {
  static Route<T> fadeThrough<T>(
    RoutePageBuilder pageBuilder, {
    RouteSettings? settings,
    Color? fillColor,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: pageBuilder,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          fillColor: fillColor,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }

  static Route<T> fadeScale<T>(
    RoutePageBuilder pageBuilder, {
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: pageBuilder,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeScaleTransition(animation: animation, child: child);
      },
    );
  }

  static Route<T> sharedAxis<T>(
    RoutePageBuilder pageBuilder, {
    RouteSettings? settings,
    Color? fillColor,
    bool maintainState = true,
    bool fullscreenDialog = false,
    SharedAxisTransitionType type = SharedAxisTransitionType.scaled,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: pageBuilder,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          child: child,
          fillColor: fillColor,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type,
        );
      },
    );
  }
}
