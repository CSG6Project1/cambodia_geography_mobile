import 'package:cached_network_image/cached_network_image.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/screens/drawer/local_widgets/diagonal_path_clipper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:in_app_review/in_app_review.dart';

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
        displayName: tr('title.home'),
        icon: Icons.home,
        isRoot: true,
      ),
      if (this.userProvider?.user?.role == "admin")
        _Route(
          routeName: RouteConfig.ADMIN,
          displayName: tr('title.admin'),
          icon: Icons.admin_panel_settings,
          isRoot: true,
        ),
      if (this.userProvider?.isSignedIn == true)
        _Route(
          isRoot: false,
          routeName: RouteConfig.BOOKMARK,
          displayName: tr('title.bookmark'),
          icon: Icons.bookmark,
          overrideOnTap: () {},
        ),
      _Route(
        isRoot: false,
        routeName: RouteConfig.USER,
        displayName: tr('title.setting'),
        icon: Icons.settings,
        overrideOnTap: () {},
      ),
      _Route(
        routeName: "",
        displayName: tr('tile.rate_us.title'),
        icon: Icons.rate_review,
        overrideOnTap: () async {
          Navigator.of(context).pop();
          InAppReview inAppReview = InAppReview.instance;
          PackageInfo packageInfo = await PackageInfo.fromPlatform().then((value) => value);
          inAppReview.openStoreListing(appStoreId: packageInfo.packageName);
        },
      ),
      _Route(
        routeName: "",
        displayName: tr('tile.help'),
        icon: Icons.help,
        overrideOnTap: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(RouteConfig.HELP);
        },
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context, listen: true);
  }

  void onUserTilePress({bool forceOpenUser = false}) {
    Navigator.of(context).pop();
    if (userProvider?.isSignedIn == true || forceOpenUser) {
      Navigator.of(context).pushNamed(RouteConfig.USER);
    } else {
      Navigator.of(context).pushNamed(RouteConfig.LOGIN);
    }
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
          if (kIsWeb) const VerticalDivider(width: 0),
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
                  if (route.overrideOnTap != null) route.overrideOnTap!();
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
      right: 0,
      left: 0,
      child: AnimatedContainer(
        duration: ConfigConstant.fadeDuration,
        margin: EdgeInsets.only(
          top: userProvider?.isSignedIn == true && user?.email != null ? 24 + 1 : 40 + 1,
        ),
        padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
              child: Stack(
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
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(ConfigConstant.objectHeight2),
                        onTap: () => onUserTilePress(forceOpenUser: true),
                      ),
                    ),
                  )
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: ConfigConstant.fadeDuration,
              sizeCurve: Curves.ease,
              crossFadeState: userProvider?.isSignedIn == true ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              secondChild: Material(
                color: Colors.transparent,
                child: ListTile(
                  onTap: onUserTilePress,
                  tileColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
                  trailing: Icon(Icons.arrow_right, color: colorScheme.onPrimary),
                  title: Text(
                    userProvider?.isSignedIn == true ? "..." : "Login",
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                ),
              ),
              firstChild: Material(
                color: Colors.transparent,
                child: ListTile(
                  onTap: onUserTilePress,
                  tileColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
                  trailing: Icon(Icons.arrow_right, color: colorScheme.onPrimary),
                  title: AnimatedCrossFade(
                    duration: ConfigConstant.fadeDuration,
                    sizeCurve: Curves.ease,
                    crossFadeState: user != null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    firstChild: Text(
                      user?.username ?? "",
                      style: TextStyle(color: colorScheme.onPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    secondChild: Text(
                      "...",
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                  ),
                  subtitle: user?.email != null
                      ? Text(
                          user?.email ?? "",
                          style: TextStyle(
                            color: colorScheme.onPrimary.withOpacity(0.5),
                          ),
                          maxLines: 1,
                        )
                      : null,
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
