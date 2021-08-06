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
    this.isLoading = false,
    required this.onTap,
  });

  final PlaceModel? place;
  final bool isLoading;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2, vertical: ConfigConstant.margin1),
      shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadius1),
      child: ClipRRect(
        borderRadius: ConfigConstant.circlarRadius1,
        child: CgOnTapEffect(
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              buildCardImage(context),
              buildCardInfo(colorScheme, textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardImage(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: ConfigConstant.fadeDuration,
      sizeCurve: Curves.ease,
      firstChild: CgCustomShimmer(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
      secondChild: AspectRatio(
        aspectRatio: 16 / 9,
        child: CgNetworkImageLoader(
          imageUrl: place?.images?.isNotEmpty == true ? place?.images?.first.url : null,
          fit: BoxFit.cover,
          height: ConfigConstant.objectHeight1,
        ),
      ),
    );
  }

  Widget buildCardInfo(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          const Divider(height: 0, thickness: 0.5),
          isLoading ? buildLoadingTitle(colorScheme) : buildLoadedTitle(colorScheme, textTheme),
        ],
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
