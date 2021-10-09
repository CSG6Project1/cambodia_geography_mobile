import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/models/tb_commune_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/models/tb_village_model.dart';
import 'package:cambodia_geography/services/geography/geography_search_service.dart';

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
        Iterable<TbProvinceModel> result = CambodiaGeography.instance.tbProvinces.where((e) => e.code == code);
        if (result.isNotEmpty) {
          Navigator.of(context).pushNamed(
            RouteConfig.PROVINCE_DETAIL,
            arguments: result.first,
          );
        }
        break;
      case "DISTRICT":
        Iterable<TbDistrictModel> result = CambodiaGeography.instance.tbDistricts.where((e) => e.code == code);
        if (result.isNotEmpty) {
          Navigator.of(context).pushNamed(
            RouteConfig.DISTRICT,
            arguments: result.first,
          );
        }
        break;
      case "COMMUNE":
        Iterable<TbCommuneModel> result = CambodiaGeography.instance.tbCommunes.where((e) => e.code == code);
        if (result.isNotEmpty) {
          Navigator.of(context).pushNamed(
            RouteConfig.DISTRICT,
            arguments: result.first,
          );
        }
        break;
      case "VILLAGE":
        Iterable<TbVillageModel> result = CambodiaGeography.instance.tbVillages.where((e) => e.code == code);
        if (result.isNotEmpty) {
          Navigator.of(context).pushNamed(
            RouteConfig.DISTRICT,
            arguments: result.first,
          );
        }
        break;
    }
  }
}
