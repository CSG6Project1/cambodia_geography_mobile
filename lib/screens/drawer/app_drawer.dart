import 'package:cached_network_image/cached_network_image.dart';
import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:cambodia_geography/screens/drawer/drawer_wrapper.dart';
import 'package:cambodia_geography/screens/drawer/local_widgets/diagonal_path_clipper.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _Route {
  final String routeName;
  final String displayName;
  final IconData icon;
  final void Function()? overrideOnTap;
  final bool isRoot;

  _Route({
    required this.routeName,
    required this.displayName,
    required this.icon,
    this.overrideOnTap,
    this.isRoot = false,
  });
}

class _AppDrawerState extends State<AppDrawer> with CgMediaQueryMixin, CgThemeMixin {
  UserModel? user;

  List<_Route> get routes {
    return [
      _Route(
        routeName: RouteConfig.HOME,
        displayName: "Home",
        icon: Icons.home,
        isRoot: true,
      ),
      _Route(
        routeName: RouteConfig.ADMIN,
        displayName: "Admin",
        icon: Icons.admin_panel_settings,
        isRoot: true,
      ),
      _Route(
        routeName: "",
        displayName: "Rate us",
        icon: Icons.rate_review,
        overrideOnTap: () {},
      ),
      _Route(
        routeName: "",
        displayName: "About us",
        icon: Icons.info,
        overrideOnTap: () {},
      ),
    ];
  }

  @override
  void initState() {
    user = App.of(context)?.userNotifier.value;
    if (App.of(context)?.userNotifier != null) {
      App.of(context)?.userNotifier.addListener(() {
        setState(() {
          user = App.of(context)?.userNotifier.value;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeData,
      child: Container(
        margin: EdgeInsets.only(right: kToolbarHeight),
        child: Scaffold(
          extendBody: true,
          backgroundColor: colorScheme.surface,
          extendBodyBehindAppBar: true,
          body: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      color: colorScheme.primary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildDrawerHeader(),
            buildListTiles(),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(color: colorScheme.primary),
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          buildBackground(),
          buildUserInfo(),
        ],
      ),
    );
  }

  Widget buildListTiles() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return Container(
      color: colorScheme.surface,
      child: Column(
        children: List.generate(
          routes.length,
          (index) {
            var route = routes[index];
            bool selected = currentRoute == route.routeName;
            return Material(
              child: ListTile(
                enabled: true,
                selected: selected,
                selectedTileColor: colorScheme.background,
                tileColor: colorScheme.surface,
                title: Text(route.displayName),
                leading: Icon(route.icon),
                onTap: () async {
                  if (route.routeName.isEmpty) return;
                  await DrawerWrapper.of(context)?.close();
                  if (selected) return;
                  await Future.delayed(Duration(milliseconds: 50));
                  if (route.isRoot) {
                    Navigator.of(context).pushReplacementNamed(route.routeName);
                  } else {
                    Navigator.of(context).pushNamed(route.routeName);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildUserInfo() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.all(ConfigConstant.margin2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: colorScheme.surface,
              child: Container(
                padding: const EdgeInsets.all(ConfigConstant.margin2),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(),
                ),
              ),
              foregroundImage:
                  user?.profileImg?.url != null ? CachedNetworkImageProvider(user?.profileImg?.url ?? "") : null,
            ),
            AnimatedCrossFade(
              duration: ConfigConstant.fadeDuration,
              sizeCurve: Curves.ease,
              crossFadeState: user != null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              secondChild: ListTile(
                onTap: () {},
                tileColor: Colors.red,
                hoverColor: Colors.blue,
                contentPadding: EdgeInsets.zero,
                title: Text("...", style: TextStyle(color: colorScheme.onPrimary)),
              ),
              firstChild: ListTile(
                onTap: () {},
                tileColor: Colors.red,
                hoverColor: Colors.blue,
                contentPadding: EdgeInsets.zero,
                title: Text(user?.username ?? "", style: TextStyle(color: colorScheme.onPrimary)),
                subtitle: Text(
                  user?.email ?? "",
                  style: TextStyle(
                    color: colorScheme.onPrimary.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBackground() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ClipPath(
        clipper: DiagonalPathClipper(),
        child: Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.onPrimary.withOpacity(0),
                colorScheme.onPrimary.withOpacity(0.37),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
