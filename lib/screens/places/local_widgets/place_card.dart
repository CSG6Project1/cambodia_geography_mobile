import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/helpers/number_helper.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
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
                child: Text(place?.provinceCode ?? ""),
              ),
            ),
            buildAnimatedCrossFade(
              loading: place?.khmer == null,
              loadingWidget: const SizedBox(width: double.infinity),
              child: Row(
                children: [
                  Row(
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
                  ),
                  const SizedBox(width: ConfigConstant.margin1),
                  Row(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoadedTitle(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: ConfigConstant.margin2,
        vertical: ConfigConstant.margin1,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              place?.khmer ?? "",
              maxLines: 1,
              style: textTheme.bodyText1,
            ),
          ),
          Text(
            NumberHelper.toKhmer((place?.commentLength ?? 0).toString()),
            style: textTheme.caption,
          ),
          const SizedBox(width: ConfigConstant.margin0),
          Icon(
            Icons.mode_comment,
            size: ConfigConstant.iconSize1,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget buildLoadingTitle(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surface,
      height: ConfigConstant.objectHeight1,
      padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CgCustomShimmer(
            child: Container(
              height: 14,
              width: 200,
              color: colorScheme.surface,
            ),
          ),
          CgCustomShimmer(
            child: Container(
              height: 14,
              width: 20,
              color: colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }
}
