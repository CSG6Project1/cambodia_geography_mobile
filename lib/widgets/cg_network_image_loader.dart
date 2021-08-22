import 'package:cached_network_image/cached_network_image.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class CgNetworkImageLoader extends StatelessWidget {
  const CgNetworkImageLoader({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.showError = true,
  }) : super(key: key);

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) return buildNoImage();
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      errorWidget: (context, url, error) {
        return buildNoImage();
      },
    );
  }

  Widget buildNoImage() {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(ConfigConstant.margin2),
      child: showError
          ? Image.asset(
              Assets.images.helperImage.placeholder.path,
              width: width,
              height: height,
              fit: fit,
            )
          : null,
    );
  }
}
