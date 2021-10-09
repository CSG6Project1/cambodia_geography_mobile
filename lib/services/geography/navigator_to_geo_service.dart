import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/exports/exports.dart';

class NavigatorToGeoService {
  void exec({
    required BuildContext context,
    required String code,
  }) {
    String? type;

    if (code.length == 2) {
      type = "PROVINCE";
    }
    if (code.length == 4) {
      type = "DISTRICT";
    }
    if (code.length == 6) {
      type = "COMMUNE";
    }
    if (code.length == 8) {
      type = "VILLAGE";
    }

    switch (type) {
      case "PROVINCE":
        break;
      case "DISTRICT":
        break;
      case "COMMUNE":
        break;
      case "VILLAGE":
        break;
    }

    Navigator.of(context).pushNamed(RouteConfig.DISTRICT);
  }
}
