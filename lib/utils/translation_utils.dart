import 'package:cambodia_geography/exports/exports.dart';
import 'package:easy_localization/easy_localization.dart';

String customTr({
  required String km,
  required String en,
  required BuildContext context,
}) {
  switch (context.locale.languageCode) {
    case "km":
      return km;
    case "en":
      return en;
    default:
      return km;
  }
}
