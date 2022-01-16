import 'dart:io';
import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/cg_page_route.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/models/user/confirmation_model.dart';
import 'package:cambodia_geography/screens/404/not_found_screen.dart';
import 'package:cambodia_geography/screens/admin/admin_screen.dart';
import 'package:cambodia_geography/screens/admin/body_editor_screen.dart';
import 'package:cambodia_geography/screens/admin/edit_place_screen.dart';
import 'package:cambodia_geography/screens/auth/login_screen.dart';
import 'package:cambodia_geography/screens/auth/signup_screen.dart';
import 'package:cambodia_geography/screens/auth/confirmation_screen.dart';
import 'package:cambodia_geography/screens/comment/comment_screen.dart';
import 'package:cambodia_geography/screens/district/district_screen.dart';
import 'package:cambodia_geography/screens/district/reference_screen.dart';
import 'package:cambodia_geography/screens/drawer/help_screen.dart';
import 'package:cambodia_geography/screens/home/home_screen.dart';
import 'package:cambodia_geography/screens/init/init_language_screen.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:cambodia_geography/screens/place_detail/place_detail_screen.dart';
import 'package:cambodia_geography/screens/places/places_screen.dart';
import 'package:cambodia_geography/screens/province/province_detail_screen.dart';
import 'package:cambodia_geography/screens/search/search_filter_screen.dart';
import 'package:cambodia_geography/screens/user/bookmark_screen.dart';
import 'package:cambodia_geography/screens/user/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class CgRouteSetting {
  final Widget Function(dynamic) route;
  final bool isRoot;
  final String title;
  final bool fullscreenDialog;
  final bool canSwap;
  final Widget? screen;
  final Color? fillColor;

  CgRouteSetting({
    required this.isRoot,
    required this.title,
    required this.route,
    this.canSwap = true,
    this.fullscreenDialog = false,
    this.screen,
    this.fillColor,
  });
}

class RouteConfig {
  final RouteSettings? settings;
  final BuildContext? context;

  RouteConfig({
    this.settings,
    this.context,
  });

  static const String HOME = '/home';
  static const String DISTRICT = '/district';
  static const String LOGIN = '/auth/login';
  static const String INIT_LANG = '/init_lang';
  static const String SIGNUP = '/auth/signup';
  static const String CONFIRMATION = '/auth/confirmation';
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
  static const String COMMENT = '/comment';
  static const String NOTFOUND = '/404';
  static const String ABOUT_US = '/about_us';
  static const String HELP = '/help';
  static const String REFERENCE = '/reference';

  /// List of route that use custom page route
  /// instead of `SwipeablePageRoute`
  static const List<String> routesWithCustomTransitions = [LOGIN, SIGNUP];

  Route<dynamic> generate() {
    String? name = settings?.name;
    if (!routes.containsKey(name) || name == null) name = NOTFOUND;
    if (routesWithCustomTransitions.contains(name)) {
      return CgPageRoute.sharedAxis(
        builder: routes[name]!.route,
        fillColor: routes[name]?.fillColor,
      );
    } else {
      if (Platform.isIOS) {
        return SwipeablePageRoute(
          canSwipe: routes[name]?.canSwap == true && !(routes[name]?.isRoot == true),
          canOnlySwipeFromEdge: routes[name]?.canSwap == true && !(routes[name]?.isRoot == true),
          settings: settings?.copyWith(arguments: routes[name]!),
          builder: routes[name]!.route,
          fullscreenDialog: routes[name]!.fullscreenDialog,
        );
      } else {
        return MaterialPageRoute(
          settings: settings?.copyWith(arguments: routes[name]!),
          builder: routes[name]!.route,
          fullscreenDialog: routes[name]!.fullscreenDialog,
        );
      }
    }
  }

  Map<String, CgRouteSetting> get routes {
    return {
      '/': CgRouteSetting(
        isRoot: true,
        title: "HOME",
        screen: HomeScreen(),
        route: (context) => HomeScreen(),
      ),
      HOME: CgRouteSetting(
        isRoot: true,
        title: "HOME",
        screen: HomeScreen(),
        route: (context) => HomeScreen(),
      ),
      DISTRICT: CgRouteSetting(
        isRoot: false,
        title: "DISTRICT",
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is TbDistrictModel) {
            return DistrictScreen(
              geo: GeoModel(district: arguments),
            );
          } else if (arguments is GeoModel) {
            return DistrictScreen(
              geo: arguments,
            );
          }
          return NotFoundScreen();
        },
      ),
      LOGIN: CgRouteSetting(
        isRoot: false,
        title: "LOGIN",
        screen: LoginScreen(),
        fillColor: context != null ? Theme.of(context!).colorScheme.surface : null,
        route: (context) => LoginScreen(),
      ),
      SIGNUP: CgRouteSetting(
        isRoot: false,
        title: "SIGNUP",
        fillColor: context != null ? Theme.of(context!).colorScheme.primary : null,
        screen: SignUpScreen(),
        route: (context) => SignUpScreen(),
      ),
      CONFIRMATION: CgRouteSetting(
        isRoot: false,
        title: "VERIFY_EMAIL",
        fullscreenDialog: true,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is ConfirmationModel) return ConfirmationScreen(confirmation: arguments);
          return NotFoundScreen();
        },
      ),
      INIT_LANG: CgRouteSetting(
        isRoot: false,
        title: "INIT_LANG",
        screen: InitLanguageScreen(),
        route: (context) => InitLanguageScreen(),
      ),
      PLACES: CgRouteSetting(
        isRoot: false,
        title: "PLACES",
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is TbProvinceModel) return PlacesScreen(province: arguments);
          return NotFoundScreen();
        },
      ),
      PLACEDETAIL: CgRouteSetting(
        isRoot: false,
        title: "PLACEDETAIL",
        route: (context) {
          Object? arg = settings?.arguments;
          if (arg is PlaceModel) {
            if (arg.type == "province") {
              return ProvinceDetailScreen(
                info: arg,
                province: CambodiaGeography.instance.tbProvinces.where((e) {
                  return e.code == arg.provinceCode;
                }).first,
              );
            } else {
              return PlaceDetailScreen(place: arg);
            }
          }
          return NotFoundScreen();
        },
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
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is PlaceModel) return SearchFilterScreen(filter: arguments);
          return SearchFilterScreen();
        },
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
        route: (context) {
          Object? arg = settings?.arguments;
          if (arg == null) return EditPlaceScreen(place: null);
          if (arg is PlaceModel) return EditPlaceScreen(place: arg);
          return NotFoundScreen();
        },
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
        screen: UserScreen(),
        fullscreenDialog: true,
        route: (context) => UserScreen(),
        fillColor: context != null ? Theme.of(context!).colorScheme.surface : null,
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
      COMMENT: CgRouteSetting(
        isRoot: false,
        title: "COMMENT",
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is PlaceModel) return CommentScreen(place: arguments);
          return NotFoundScreen();
        },
        fullscreenDialog: true,
      ),
      NOTFOUND: CgRouteSetting(
        isRoot: false,
        title: "NOT FOUND",
        route: (context) => NotFoundScreen(),
      ),
      // ABOUT_US: CgRouteSetting(
      //   isRoot: false,
      //   fullscreenDialog: true,
      //   canSwap: false,
      //   title: "ABOUT US",
      //   route: (context) => AboutUsScreen(),
      // ),
      HELP: CgRouteSetting(
        isRoot: false,
        fullscreenDialog: true,
        canSwap: false,
        title: "HELP ABOUT",
        route: (context) => HelpScreen(),
      ),
      REFERENCE: CgRouteSetting(
        isRoot: false,
        fullscreenDialog: false,
        canSwap: false,
        title: "REFERENCE",
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is GeoModel) return ReferenceScreen(geo: arguments);
          return NotFoundScreen();
        },
      ),
    };
  }
}
