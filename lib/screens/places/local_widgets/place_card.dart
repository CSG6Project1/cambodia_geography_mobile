import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/helper/number_helper.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/widgets/cg_custom_shimmer.dart';
import 'package:cambodia_geography/widgets/cg_network_image_loader.dart';
import 'package:cambodia_geography/widgets/cg_on_tap_effect.dart';
import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  PlaceCard({
    this.place,
    this.isLoading = false,
  });

  final PlaceModel? place;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    if (isLoading) return buildLoadingCard(context);
    if (place == null) return SizedBox();
    return buildCard(
      context,
      colorScheme,
      textTheme,
    );
  }

  Widget buildCard(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: ConfigConstant.margin2,
        vertical: ConfigConstant.margin1,
      ),
      shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadius1),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            child: CgOnTapEffect(
              onTap: () {
                Navigator.of(context).pushNamed(RouteConfig.PLACEDETAIL, arguments: place);
              },
              child: AspectRatio(
                aspectRatio: 2 / 1,
                child: Container(
                  child: place!.images == null || place!.images?.length == 0
                      ? Image.asset('assets/images/helper_image/placeholder.png')
                      : CgNetworkImageLoader(
                          imageUrl: place!.images![0].url ?? '',
                          fit: BoxFit.cover,
                          height: ConfigConstant.objectHeight1,
                        ),
                ),
              ),
            ),
          ),
          const Divider(height: 0, thickness: 0.5),
          Container(
            height: ConfigConstant.objectHeight1,
            padding: EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    place!.khmer.toString(),
                    style: textTheme.bodyText1,
                  ),
                ),
                Text(
                  NumberHelper.toKhmer((place!.commentLength ?? 0).toString()),
                  style: textTheme.caption,
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.mode_comment,
                  size: ConfigConstant.iconSize1,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildLoadingCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadius1),
      margin: const EdgeInsets.symmetric(
        horizontal: ConfigConstant.margin2,
        vertical: ConfigConstant.margin1,
      ),
      child: Column(
        children: [
          CgCustomShimmer(
            child: AspectRatio(
              aspectRatio: 2 / 1,
              child: Container(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          const Divider(height: 0),
          Container(
            color: Theme.of(context).colorScheme.surface,
            height: ConfigConstant.objectHeight1,
            padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CgCustomShimmer(
                  child: Container(height: 14, width: 200, color: Theme.of(context).colorScheme.surface),
                ),
                CgCustomShimmer(
                  child: Container(height: 14, width: 20, color: Theme.of(context).colorScheme.surface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
