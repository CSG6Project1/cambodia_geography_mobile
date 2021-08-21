import 'package:cambodia_geography/screens/drawer/app_drawer.dart';
import 'package:flutter/material.dart';

/// A responsive scaffold for our application.
/// Displays the navigation drawer alongside the [Scaffold] if the screen/window size is large enough
class CgScaffold extends StatelessWidget {
  const CgScaffold({
    required this.body,
    this.appBar,
    this.floatingActionButton,
    Key? key,
  }) : super(key: key);

  final Widget body;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;
    return Row(
      children: [
        if (!displayMobileLayout) const AppDrawer(),
        Expanded(
          child: Scaffold(
            appBar: appBar,
            floatingActionButton: floatingActionButton,
            drawer: displayMobileLayout ? const AppDrawer() : null,
            body: body,
          ),
        )
      ],
    );
  }
}
