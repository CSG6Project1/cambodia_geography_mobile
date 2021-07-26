import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:flutter/material.dart';

class AppHelper<T> {
  AppHelper._internal();

  static dynamic getScreenTitle(BuildContext context, {String? titleFallback}) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is CgRouteSetting) {
      return arguments.title;
    } else {
      return titleFallback;
    }
  }

  static String? queryParameters({required String url, required String param}) {
    return Uri.parse(url).queryParameters[param];
  }

  static bool isLatLngValdated(LatLng latLng) {
    bool isLatitude = latLng.latitude.isFinite && latLng.latitude.abs() <= 90;
    bool isLongtitude = latLng.longitude.isFinite && latLng.latitude.abs() <= 180;
    return isLatitude && isLongtitude;
  }
}
