import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';

class AppContant {
  AppContant._internal();

  static List<String> get placeType {
    return PlaceType.values.map((e) {
      return "$e".replaceAll("PlaceType.", "");
    }).toList();
  }

  static const Locale km = Locale("km");
  static const Locale en = Locale("en");
}
