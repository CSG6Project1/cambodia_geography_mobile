import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/helpers/number_helper.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_commune_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/models/tb_village_model.dart';
import 'package:cambodia_geography/providers/editing_provider.dart';
import 'package:cambodia_geography/providers/user_location_provider.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:cambodia_geography/services/geography/distance_caculator_service.dart';
import 'package:cambodia_geography/widgets/cg_custom_shimmer.dart';
import 'package:cambodia_geography/widgets/cg_network_image_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceCard extends StatelessWidget {
  PlaceCard({
    this.place,
    required this.onTap,
    this.onDelete,
  });

  final PlaceModel? place;
  final void Function() onTap;
  final void Function()? onDelete;

  String getGeoInfo() {
    List<String> geoInfo = [];

    TbProvinceModel? province;
    TbDistrictModel? district;
    TbCommuneModel? commune;
    TbVillageModel? village;

    List<TbProvinceModel> provinces = CambodiaGeography.instance.tbProvinces.where((province) {
      return place?.provinceCode == province.code;
    }).toList();

    List<TbDistrictModel> districts = CambodiaGeography.instance.tbDistricts.where((district) {
      return place?.districtCode == district.code;
    }).toList();

    List<TbCommuneModel> communes = CambodiaGeography.instance.tbCommunes.where((commune) {
      return place?.communeCode == commune.code;
    }).toList();

    List<TbVillageModel> villages = CambodiaGeography.instance.tbVillages.where((village) {
      return place?.villageCode == village.code;
    }).toList();

    if (provinces.isNotEmpty) {
      province = provinces.first;
      if (province.khmer != null) geoInfo.add(province.khmer ?? "");
    }
    if (districts.isNotEmpty) {
      district = districts.first;
      if (district.khmer != null) geoInfo.add(district.khmer ?? "");
    }
    if (communes.isNotEmpty) {
      commune = communes.first;
      if (commune.khmer != null) geoInfo.add(commune.khmer ?? "");
    }
    if (villages.isNotEmpty) {
      village = villages.first;
      if (village.khmer != null) geoInfo.add(village.khmer ?? "");
    }

    return geoInfo.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadius1),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            buildCardInfo(colorScheme, textTheme),
            buildCardImage(context),
          ],
        ),
      ),
    );
  }

  Widget buildCardImage(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: place?.images == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: ConfigConstant.fadeDuration,
      sizeCurve: Curves.ease,
      firstChild: SizedBox(
        height: ConfigConstant.objectHeight6,
        width: ConfigConstant.objectHeight6,
      ),
      secondChild: Container(
        height: ConfigConstant.objectHeight6,
        width: ConfigConstant.objectHeight6,
        padding: const EdgeInsets.all(ConfigConstant.margin1),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              CgNetworkImageLoader(
                imageUrl: place?.images?.isNotEmpty == true ? place?.images?.first.url : null,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              if (onDelete != null)
                Consumer<EditingProvider>(
                  builder: (context, provider, child) {
                    bool showDeleteButton = onDelete != null && provider.editing;
                    return IgnorePointer(
                      ignoring: !showDeleteButton,
                      child: AnimatedOpacity(
                        opacity: showDeleteButton ? 1 : 0,
                        duration: ConfigConstant.fadeDuration ~/ 2,
                        child: Material(
                          color: Theme.of(context).colorScheme.background,
                          child: InkWell(
                            onTap: onDelete,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAnimatedCrossFade({
    required Widget loadingWidget,
    required Widget child,
    required bool loading,
  }) {
    return AnimatedCrossFade(
      firstChild: child,
      secondChild: loadingWidget,
      sizeCurve: Curves.ease,
      crossFadeState: loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: ConfigConstant.fadeDuration,
    );
  }

  Widget buildCardInfo(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Expanded(
      child: ListTile(
        title: buildAnimatedCrossFade(
          loading: place?.khmer == null,
          loadingWidget: CgCustomShimmer(
            child: Container(height: 14, width: 200, color: colorScheme.surface),
          ),
          child: Text(
            place?.khmer ?? "",
            style: TextStyle(color: colorScheme.primary),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAnimatedCrossFade(
              loading: place?.provinceCode == null,
              loadingWidget: Container(
                width: double.infinity,
                child: CgCustomShimmer(
                  child: Row(
                    children: [
                      Container(height: 14, width: 100, color: colorScheme.surface),
                    ],
                  ),
                ),
              ),
              child: Container(
                width: double.infinity,
                child: Text(getGeoInfo()),
              ),
            ),
            const SizedBox(height: ConfigConstant.margin0),
            buildAnimatedCrossFade(
              loading: place?.khmer == null,
              loadingWidget: const SizedBox(width: double.infinity),
              child: Row(
                children: [
                  buildComment(colorScheme, textTheme),
                  const SizedBox(width: ConfigConstant.margin1),
                  buildDistance(colorScheme, textTheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDistance(ColorScheme colorScheme, TextTheme textTheme) {
    return Consumer<UserLocationProvider>(
      builder: (context, value, child) {
        double? distance;
        if (value.currentPosition != null) {
          LatLng? placeLatLng;
          if (place?.lat != null && place?.lat != null) placeLatLng = LatLng(place!.lat!, place!.lon!);
          LatLng? userLatLng = LatLng(value.currentPosition!.latitude, value.currentPosition!.longitude);
          if (placeLatLng != null) {
            distance = DistanceCaculatorService.calculateDistance(placeLatLng, userLatLng);
          }
        }

        return Expanded(
          child: buildAnimatedCrossFade(
            loading: distance == null,
            loadingWidget: const SizedBox(
              width: double.infinity,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.place,
                  size: ConfigConstant.iconSize1,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(width: ConfigConstant.margin0),
                Expanded(
                  child: Text(
                    distance != null ? NumberHelper.toKhmer(distance.toStringAsFixed(2) + " គីឡូម៉ែត្រ") : "",
                    style: textTheme.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildComment(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Icon(
          Icons.mode_comment,
          size: ConfigConstant.iconSize1,
          color: colorScheme.primary,
        ),
        const SizedBox(width: ConfigConstant.margin0),
        Text(
          NumberHelper.toKhmer((place?.commentLength ?? 0).toString()),
          style: textTheme.caption,
        ),
      ],
    );
  }
}
