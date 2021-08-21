import 'package:cached_network_image/cached_network_image.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:cambodia_geography/providers/theme_provider.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/screens/drawer/local_widgets/diagonal_path_clipper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late UserProvider? userProvider;
  UserModel? get user => this.userProvider?.user;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeData,
      child: Row(
        children: [
          Drawer(
            // width: min(350, mediaQueryData.size.width) - kToolbarHeight,
            child: Scaffold(
              extendBody: true,
              backgroundColor: colorScheme.surface,
              extendBodyBehindAppBar: true,
              body: buildBody(),
            ),
          ),
          const VerticalDivider(width: 0),
        ],
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
                  if (selected) return;
                  if (Scaffold.hasDrawer(context)) Navigator.of(context).pop();
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
              foregroundImage:
                  user?.profileImg?.url != null ? CachedNetworkImageProvider(user?.profileImg?.url ?? "") : null,
              child: Container(
                padding: const EdgeInsets.all(ConfigConstant.margin2),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Icon(
                    Icons.person,
                    size: ConfigConstant.iconSize1,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: ConfigConstant.fadeDuration,
              sizeCurve: Curves.ease,
              crossFadeState: user != null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              secondChild: ListTile(
                onTap: () {
                  if (userProvider?.isSignedIn == true) return;
                  Navigator.of(context).pushNamed(RouteConfig.LOGIN);
                },
                tileColor: Colors.red,
                hoverColor: Colors.blue,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  userProvider?.isSignedIn == true ? "..." : "Login",
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
                trailing: Wrap(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        color: colorScheme.surface,
                        icon: Icon(Icons.login),
                        onPressed: () async {
                          if (userProvider?.isSignedIn == true) return;
                          Navigator.of(context).pushNamed(RouteConfig.LOGIN);
                        },
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        color: colorScheme.surface,
                        icon: Icon(Icons.dark_mode),
                        onPressed: () async {
                          Provider.of<ThemeProvider>(context, listen: false).toggleDarkMode();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              firstChild: ListTile(
                onTap: () {},
                tileColor: Colors.red,
                hoverColor: Colors.blue,
                contentPadding: EdgeInsets.zero,
                title: Text(user?.username ?? "", style: TextStyle(color: colorScheme.onPrimary)),
                trailing: Wrap(
                  children: [
                    // Material(
                    //   color: Colors.transparent,
                    //   child: IconButton(
                    //     color: colorScheme.surface,
                    //     icon: Icon(Icons.logout),
                    //     onPressed: () async {
                    //       await userProvider?.signOut();
                    //       Scaffold.of(context).openDrawer();
                    //     },
                    //   ),
                    // ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        color: colorScheme.surface,
                        icon: Icon(Icons.dark_mode),
                        onPressed: () async {
                          Provider.of<ThemeProvider>(context, listen: false).toggleDarkMode();
                        },
                      ),
                    ),
                  ],
                ),
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
