import 'package:cambodia_geography/configs/route_config.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          children: List.generate(
            RouteConfig().routes.length,
            (index) {
              final item = RouteConfig().routes.keys.toList()[index];
              final value = RouteConfig().routes.values.toList()[index];
              return ListTile(
                title: Text(item),
                selected: currentRoute == item,
                onTap: () {
                  Navigator.of(context).pop();
                  if (currentRoute == item) return;
                  if (value.isRoot) {
                    Navigator.of(context).pushReplacementNamed(item);
                  } else {
                    Navigator.of(context).pushNamed(item);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
