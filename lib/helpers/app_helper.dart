import 'package:cambodia_geography/configs/route_config.dart';
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

  /// Latitude must be a number between -90 and 90
  /// Longitude must a number between -180 and 180
  static bool isLatLngValdated(double latitude, double longitude) {
    bool isLatitude = latitude.isFinite && latitude.abs() <= 90;
    bool isLongtitude = longitude.isFinite && longitude.abs() <= 180;
    return isLatitude && isLongtitude;
  }

  static Map<String, dynamic> filterOutNull(Map<String, dynamic> json) {
    json.forEach((key, value) {
      dynamic value = json[key];
      if (value != null && value is List) {
        value.removeWhere((e) => e == null || e == "null");
        json[key] = value;
      }
    });
    json.removeWhere((key, value) => value == null || value == "null" || (value is List && value.isEmpty));
    return json;
  }
}
