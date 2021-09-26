import 'package:cambodia_geography/app.dart';

abstract class BaseModel {
  String? get nameTr {
    return tr(km, en);
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
