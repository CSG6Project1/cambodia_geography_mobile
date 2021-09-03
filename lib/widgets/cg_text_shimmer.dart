import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:flutter/material.dart';

import 'cg_custom_shimmer.dart';

class CgTextShimmer extends StatelessWidget {
  CgTextShimmer({Key? key, this.height, this.width}) : super(key: key);

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CgCustomShimmer(
      child: Container(
        margin: EdgeInsets.only(bottom: ConfigConstant.margin1),
        height: height ?? 16,
        width: width ?? 100,
        color: Colors.white,
      ),
    );
  }
}
