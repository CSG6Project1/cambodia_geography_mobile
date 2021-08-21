import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/helpers/number_helper.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_commune_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/models/tb_village_model.dart';
import 'package:cambodia_geography/widgets/cg_custom_shimmer.dart';
import 'package:cambodia_geography/widgets/cg_network_image_loader.dart';
import 'package:cambodia_geography/widgets/cg_on_tap_effect.dart';
import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  PlaceCard({
    this.place,
    required this.onTap,
  });

  final PlaceModel? place;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadius1),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child: CgOnTapEffect(
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
          child: CgNetworkImageLoader(
            imageUrl: place?.images?.isNotEmpty == true ? place?.images?.first.url : null,
            fit: BoxFit.cover,
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

  String getGeoInfo() {
    List<String> geoInfo = [];

    TbProvinceModel? province;
    TbDistrictModel? district;
    TbCommuneModel? commune;
    TbVillageModel? village;

    List<TbProvinceModel> provinces =
        CambodiaGeography.instance.tbProvinces.where((province) => place?.provinceCode == province.code).toList();
    List<TbDistrictModel> districts =
        CambodiaGeography.instance.tbDistricts.where((district) => place?.districtCode == district.code).toList();
    List<TbCommuneModel> communes =
        CambodiaGeography.instance.tbCommunes.where((commune) => place?.communeCode == commune.code).toList();
    List<TbVillageModel> villages =
        CambodiaGeography.instance.tbVillages.where((village) => place?.villageCode == village.code).toList();

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
    return Row(
      children: [
        Icon(
          Icons.place,
          size: ConfigConstant.iconSize1,
          color: colorScheme.onSurface,
        ),
        const SizedBox(width: ConfigConstant.margin0),
        Text(
          "10 Kilo",
          style: textTheme.caption,
        ),
      ],
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
