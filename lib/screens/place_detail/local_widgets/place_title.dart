import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:flutter/material.dart';

class PlaceTitle extends StatelessWidget {
  const PlaceTitle({
    Key? key,
    required this.place,
  }) : super(key: key);
  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    CambodiaGeography geo = CambodiaGeography.instance;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    TbProvinceModel province = geo.tbProvinces.firstWhere((province) => province.code == place.provinceCode);
    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.all(ConfigConstant.margin2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${place.khmer}',
            style: textTheme.headline6?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w700),
          ),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: ConfigConstant.iconSize1,
                color: colorScheme.primary,
              ),
              Text(
                '${province.khmer}',
                style: textTheme.caption,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CgButton(
                labelText: 'ទិសដៅ',
                iconData: Icons.map,
                foregroundColor: colorScheme.secondary,
                backgroundColor: colorScheme.secondary.withOpacity(0.1),
                showBorder: true,
                onPressed: () {
                  LatLng? latLng;
                  double? latitude = place.lat;
                  double? longitudes = place.lon;
                  if (latitude == null || longitudes == null || latitude > 90 || latitude < -90) return;

                  latLng = LatLng(latitude, longitudes);
                  Navigator.of(context).pushNamed(
                    RouteConfig.MAP,
                    arguments: MapScreenSetting(
                      flowType: MapFlowType.view,
                      initialLatLng: latLng,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
