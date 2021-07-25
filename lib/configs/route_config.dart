import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/screens/404/not_found_screen.dart';
import 'package:cambodia_geography/screens/admin/admin_screen.dart';
import 'package:cambodia_geography/screens/admin/body_editor_screen.dart';
import 'package:cambodia_geography/screens/admin/edit_place_screen.dart';
import 'package:cambodia_geography/screens/auth/login_screen.dart';
import 'package:cambodia_geography/screens/auth/signup_screen.dart';
import 'package:cambodia_geography/screens/district/district_screen.dart';
import 'package:cambodia_geography/screens/home/home_screen.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:cambodia_geography/screens/place_detail/place_detail_screen.dart';
import 'package:cambodia_geography/screens/places/places_screen.dart';
import 'package:cambodia_geography/screens/province/province_detail_screen.dart';
import 'package:cambodia_geography/screens/search/search_filter_screen.dart';
import 'package:cambodia_geography/screens/user/bookmark_screen.dart';
import 'package:cambodia_geography/screens/user/user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class CgRouteSetting {
  final Widget Function(dynamic) route;
  final bool isRoot;
  final String title;
  final bool fullscreenDialog;
  final bool canSwap;

  CgRouteSetting({
    required this.isRoot,
    required this.title,
    required this.route,
    this.canSwap = true,
    this.fullscreenDialog = false,
  });
}

class RouteConfig {
  final RouteSettings? settings;
  RouteConfig({this.settings});

  static const String HOME = '/home';
  static const String DISTRICT = '/district';
  static const String LOGIN = '/auth/login';
  static const String SIGNUP = '/auth/signup';
  static const String PLACES = '/places';
  static const String PLACEDETAIL = '/place/detail';
  static const String PROVINCE_DETAIL = '/province_detail';
  static const String SEARCHFILTER = '/search/filter';
  static const String SEARCHRESULT = '/search/result';
  static const String ADMIN = '/admin';
  static const String EDIT_PLACE = '/admin/edit_place';
  static const String BODY_EDITOR = '/admin/edit_place/editor';
  static const String BOOKMARK = '/user/bookmark';
  static const String USER = '/user';
  static const String MAP = '/map';
  static const String NOTFOUND = '/404';

  Route<dynamic> generate() {
    String? name = settings?.name;
    if (!routes.containsKey(name) || name == null) name = NOTFOUND;
    return SwipeablePageRoute(
      canSwipe: routes[name]?.canSwap == true,
      canOnlySwipeFromEdge: true,
      settings: settings?.copyWith(arguments: routes[name]!),
      builder: routes[name]!.route,
      fullscreenDialog: routes[name]!.fullscreenDialog,
    );
  }

  Map<String, CgRouteSetting> get routes {
    return {
      HOME: CgRouteSetting(
        isRoot: true,
        title: "HOME",
        route: (context) => HomeScreen(),
      ),
      DISTRICT: CgRouteSetting(
        isRoot: false,
        title: "DISTRICT",
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is TbDistrictModel) return DistrictScreen(district: arguments);
          return NotFoundScreen();
        },
      ),
      LOGIN: CgRouteSetting(
        isRoot: false,
        title: "LOGIN",
        route: (context) => LoginScreen(),
      ),
      SIGNUP: CgRouteSetting(
        isRoot: false,
        title: "SIGNUP",
        route: (context) => SignUpScreen(),
      ),
      PLACES: CgRouteSetting(
        isRoot: false,
        title: "PLACES",
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is TbProvinceModel)
            return PlacesScreen(
              province: arguments,
            );
          return NotFoundScreen();
        },
      ),
      PLACEDETAIL: CgRouteSetting(
        isRoot: false,
        title: "PLACEDETAIL",
        route: (context) => PlaceDetailScreen(),
      ),
      PROVINCE_DETAIL: CgRouteSetting(
        isRoot: false,
        title: "PROVINCE_DETAIL",
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is TbProvinceModel) return ProvinceDetailScreen(province: arguments);
          return NotFoundScreen();
        },
      ),
      SEARCHFILTER: CgRouteSetting(
        isRoot: false,
        title: "SEARCHFILTER",
        route: (context) => SearchFilterScreen(),
        fullscreenDialog: true,
      ),
      ADMIN: CgRouteSetting(
        isRoot: true,
        title: "ADMIN",
        route: (context) => AdminScreen(),
      ),
      EDIT_PLACE: CgRouteSetting(
        isRoot: false,
        title: "EDIT_PLACE",
        route: (context) => EditPlaceScreen(),
      ),
      BODY_EDITOR: CgRouteSetting(
        isRoot: false,
        title: "BODY_EDITOR",
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is String?) return BodyEditorScreen(body: arguments ?? "");
          return BodyEditorScreen(body: "");
        },
      ),
      BOOKMARK: CgRouteSetting(
        isRoot: false,
        title: "BOOKMARK",
        route: (context) => BookmarkScreen(),
      ),
      USER: CgRouteSetting(
        isRoot: false,
        title: "USER",
        route: (context) => UserScreen(),
      ),
      MAP: CgRouteSetting(
        isRoot: false,
        title: "MAP",
        canSwap: false,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is MapScreenSetting) return MapScreen(settings: arguments);
          return NotFoundScreen();
        },
      ),
      NOTFOUND: CgRouteSetting(
        isRoot: false,
        title: "NOT FOUND",
        route: (context) => NotFoundScreen(),
      ),
    };
  }
}
