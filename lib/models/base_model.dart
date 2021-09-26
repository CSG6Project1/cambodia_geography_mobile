import 'package:cambodia_geography/app.dart';

abstract class BaseModel {
  bool get trim => true;

  String? get nameTr {
    String? result = tr(km, en);
    if (trim) {
      result = result?.replaceAll(" Province", "");
    }
    return result;
  }

  String? tr(String? km, String? en) {
    switch (App.locale?.languageCode) {
      case "km":
        return km;
      case "en":
        return en;
      default:
        return km;
    }
  }

  String? get km;
  String? get en;
}
