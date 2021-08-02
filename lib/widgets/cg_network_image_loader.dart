import 'package:cached_network_image/cached_network_image.dart';
import 'package:cambodia_geography/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class CgNetworkImageLoader extends StatelessWidget {
  const CgNetworkImageLoader({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) return Image.asset(Assets.images.helperImage.placeholder.path);
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      errorWidget: (context, url, error) {
        return Image.asset(Assets.images.helperImage.placeholder.path);
      },
    );
  }
}
