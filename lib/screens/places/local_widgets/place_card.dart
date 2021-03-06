import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_commune_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/models/tb_village_model.dart';
import 'package:cambodia_geography/providers/bookmark_editing_provider.dart';
import 'package:cambodia_geography/providers/editing_provider.dart';
import 'package:cambodia_geography/providers/user_location_provider.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';
import 'package:cambodia_geography/services/geography/distance_caculator_service.dart';
import 'package:cambodia_geography/utils/translation_utils.dart';
import 'package:cambodia_geography/widgets/cg_custom_shimmer.dart';
import 'package:cambodia_geography/widgets/cg_network_image_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceCard extends StatelessWidget {
  PlaceCard({
    this.place,
    required this.onTap,
    this.onDelete,
    this.subtitle,
  });

  final PlaceModel? place;
  final String? subtitle;
  final void Function() onTap;
  final void Function()? onDelete;

  String? getGeoInfo() {
    if (place?.provinceCode == null) return null;

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
      if (province.nameTr != null) geoInfo.add(province.nameTr ?? "");
    }
    if (districts.isNotEmpty) {
      district = districts.first;
      if (district.nameTr != null) geoInfo.add(district.nameTr ?? "");
    }
    if (communes.isNotEmpty) {
      commune = communes.first;
      if (commune.nameTr != null) geoInfo.add(commune.nameTr ?? "");
    }
    if (villages.isNotEmpty) {
      village = villages.first;
      if (village.nameTr != null) geoInfo.add(village.nameTr ?? "");
    }

    return geoInfo.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Consumer<BookmarkEditingProvider>(
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadius1),
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              buildCardInfo(colorScheme, textTheme, context),
              buildCardImage(context),
            ],
          ),
        ),
      ),
      builder: (context, provider, card) {
        bool inBookmarkScreen = ModalRoute.of(context)?.settings.name == RouteConfig.BOOKMARK;
        bool editing = provider.editing && inBookmarkScreen;
        return Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: AnimatedOpacity(
                opacity: editing ? 1 : 0,
                duration: ConfigConstant.fadeDuration ~/ 2,
                child: Checkbox(
                  value: provider.isChecked(place?.id ?? ""),
                  onChanged: (value) {
                    provider.toggleCheckBox(place?.id ?? "");
                  },
                ),
              ),
            ),
            AnimatedContainer(
              duration: ConfigConstant.fadeDuration,
              curve: Curves.ease,
              child: card,
              margin: EdgeInsets.only(
                right: editing ? ConfigConstant.objectHeight1 + ConfigConstant.margin1 : 0,
              ),
            ),
          ],
        );
      },
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
              if (onDelete != null) buildDeleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDeleteButton() {
    return Consumer<EditingProvider>(
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
    BuildContext context,
  ) {
    String? subtitle = this.subtitle ?? getGeoInfo();
    return Expanded(
      child: ListTile(
        title: buildAnimatedCrossFade(
          loading: place?.nameTr == null,
          loadingWidget: CgCustomShimmer(
            child: Container(height: 14, width: 200, color: colorScheme.surface),
          ),
          child: Text(
            place?.nameTr ?? "",
            maxLines: 1,
            style: TextStyle(color: colorScheme.primary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAnimatedCrossFade(
              loading: subtitle == null,
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
                child: Text(
                  subtitle ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: ConfigConstant.margin0),
            if (place?.id != null)
              buildAnimatedCrossFade(
                loading: place?.nameTr == null,
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
                    distance != null ? tr('geo.km', namedArgs: {'KM': numberTr(distance.toStringAsFixed(2))}) : "",
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
          numberTr(place?.commentLength ?? 0),
          style: textTheme.caption,
        ),
      ],
    );
  }
}
