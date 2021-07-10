import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/screens/404/not_found_screen.dart';
import 'package:cambodia_geography/screens/admin/admin_screen.dart';
import 'package:cambodia_geography/screens/admin/edit_place_screen.dart';
import 'package:cambodia_geography/screens/auth/login_screen.dart';
import 'package:cambodia_geography/screens/auth/signup_screen.dart';
import 'package:cambodia_geography/screens/district/district_screen.dart';
import 'package:cambodia_geography/screens/home/home_screen.dart';
import 'package:cambodia_geography/screens/place_detail/place_detail_screen.dart';
import 'package:cambodia_geography/screens/places/places_screen.dart';
import 'package:cambodia_geography/screens/search/search_filter_screen.dart';
import 'package:cambodia_geography/screens/search/search_screen.dart';
import 'package:cambodia_geography/screens/user/bookmark_screen.dart';
import 'package:cambodia_geography/screens/user/user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class CgRouteSetting {
  final Widget Function(dynamic) route;
  final bool isRoot;
  final String title;

  CgRouteSetting(
    this.route, {
    required this.isRoot,
    required this.title,
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
  static const String SEARCH = '/search';
  static const String SEARCHFILTER = '/search/filter';
  static const String SEARCHRESULT = '/search/result';
  static const String ADMIN = '/admin';
  static const String EDIT_PLACE = '/admin/edit_place';
  static const String BOOKMARK = '/user/bookmark';
  static const String USER = '/user';
  static const String NOTFOUND = '/404';

  Route<dynamic> generate() {
    String? name = settings?.name;
    if (!routes.containsKey(name) || name == null) name = NOTFOUND;
    return SwipeablePageRoute(
      settings: settings?.copyWith(arguments: routes[name]!),
      builder: routes[name]!.route,
    );
  }

  Map<String, CgRouteSetting> get routes {
    return {
      HOME: CgRouteSetting(
        (context) => HomeScreen(),
        isRoot: true,
        title: "HOME",
      ),
      DISTRICT: CgRouteSetting(
        (context) {
          Object? arguments = settings?.arguments;
          if (arguments is TbDistrictModel) return DistrictScreen(district: arguments);
          return NotFoundScreen();
        },
        isRoot: false,
        title: "DISTRICT",
      ),
      LOGIN: CgRouteSetting(
        (context) => LoginScreen(),
        isRoot: false,
        title: "LOGIN",
      ),
      SIGNUP: CgRouteSetting(
        (context) => SignUpScreen(),
        isRoot: false,
        title: "SIGNUP",
      ),
      PLACES: CgRouteSetting(
        (context) => PlacesScreen(),
        isRoot: false,
        title: "PLACES",
      ),
      PLACEDETAIL: CgRouteSetting(
        (context) => PlaceDetailScreen(),
        isRoot: false,
        title: "PLACEDETAIL",
      ),
      SEARCH: CgRouteSetting(
        (context) => SearchScreen(),
        isRoot: false,
        title: "SEARCH",
      ),
      SEARCHFILTER: CgRouteSetting(
        (context) => SearchFilterScreen(),
        isRoot: false,
        title: "SEARCHFILTER",
      ),
      ADMIN: CgRouteSetting(
        (context) => AdminScreen(),
        isRoot: true,
        title: "ADMIN",
      ),
      EDIT_PLACE: CgRouteSetting(
        (context) => EditPlaceScreen(),
        isRoot: false,
        title: "EDIT_PLACE",
      ),
      BOOKMARK: CgRouteSetting(
        (context) => BookmarkScreen(),
        isRoot: false,
        title: "BOOKMARK",
      ),
      USER: CgRouteSetting(
        (context) => UserScreen(),
        isRoot: false,
        title: "USER",
      ),
      NOTFOUND: CgRouteSetting(
        (context) => NotFoundScreen(),
        isRoot: false,
        title: "USER",
      ),
    };
  }
}
