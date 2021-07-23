import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CgCustomShimmer extends StatelessWidget {
  final Widget child;
  const CgCustomShimmer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: child,
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
    );
  }
}
