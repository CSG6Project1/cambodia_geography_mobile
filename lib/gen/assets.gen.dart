/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  $AssetsImagesHelperImageGen get helperImage =>
      const $AssetsImagesHelperImageGen();
  $AssetsImagesProvincesGen get provinces => const $AssetsImagesProvincesGen();
}

class $AssetsImagesHelperImageGen {
  const $AssetsImagesHelperImageGen();

  AssetGenImage get placeholder =>
      const AssetGenImage('assets/images/helper_image/placeholder.png');
}

class $AssetsImagesProvincesGen {
  const $AssetsImagesProvincesGen();

  AssetGenImage get banteaymeanchey =>
      const AssetGenImage('assets/images/provinces/banteaymeanchey.jpg');
  AssetGenImage get battambong =>
      const AssetGenImage('assets/images/provinces/battambong.jpg');
  AssetGenImage get kampongcham =>
      const AssetGenImage('assets/images/provinces/kampongcham.jpg');
  AssetGenImage get kampongchhnang =>
      const AssetGenImage('assets/images/provinces/kampongchhnang.jpg');
  AssetGenImage get kampongspeu =>
      const AssetGenImage('assets/images/provinces/kampongspeu.jpg');
  AssetGenImage get kampongthom =>
      const AssetGenImage('assets/images/provinces/kampongthom.jpg');
  AssetGenImage get kampot =>
      const AssetGenImage('assets/images/provinces/kampot.jpg');
  AssetGenImage get kandal =>
      const AssetGenImage('assets/images/provinces/kandal.jpg');
  AssetGenImage get kep =>
      const AssetGenImage('assets/images/provinces/kep.jpg');
  AssetGenImage get kohkong =>
      const AssetGenImage('assets/images/provinces/kohkong.jpg');
  AssetGenImage get kratie =>
      const AssetGenImage('assets/images/provinces/kratie.jpg');
  AssetGenImage get mondulkiri =>
      const AssetGenImage('assets/images/provinces/mondulkiri.jpg');
  AssetGenImage get oddarmeanchey =>
      const AssetGenImage('assets/images/provinces/oddarmeanchey.jpg');
  AssetGenImage get pailin =>
      const AssetGenImage('assets/images/provinces/pailin.jpg');
  AssetGenImage get phnompenh =>
      const AssetGenImage('assets/images/provinces/phnompenh.jpg');
  AssetGenImage get preahsihanouk =>
      const AssetGenImage('assets/images/provinces/preahsihanouk.jpg');
  AssetGenImage get preahvihear =>
      const AssetGenImage('assets/images/provinces/preahvihear.jpg');
  AssetGenImage get preyveng =>
      const AssetGenImage('assets/images/provinces/preyveng.jpg');
  AssetGenImage get pursat =>
      const AssetGenImage('assets/images/provinces/pursat.jpg');
  AssetGenImage get ratanakkiri =>
      const AssetGenImage('assets/images/provinces/ratanakkiri.jpg');
  AssetGenImage get siemreap =>
      const AssetGenImage('assets/images/provinces/siemreap.jpg');
  AssetGenImage get stungtreng =>
      const AssetGenImage('assets/images/provinces/stungtreng.jpg');
  AssetGenImage get svayreang =>
      const AssetGenImage('assets/images/provinces/svayreang.jpg');
  AssetGenImage get takao =>
      const AssetGenImage('assets/images/provinces/takao.jpg');
  AssetGenImage get tboungkhmum =>
      const AssetGenImage('assets/images/provinces/tboungkhmum.jpg');
}

class Assets {
  Assets._();

  static const String cambodiaGeography = 'assets/cambodia_geography.zip';
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const String tbCommune = 'assets/tb_commune.json';
  static const String tbDistrict = 'assets/tb_district.json';
  static const String tbProvince = 'assets/tb_province.json';
  static const String tbVillage = 'assets/tb_village.json';
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
