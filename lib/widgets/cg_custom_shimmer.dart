import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CgCustomShimmer extends StatelessWidget {
  final Widget child;
  const CgCustomShimmer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: child,
      highlightColor: Theme.of(context).colorScheme.surface,
      baseColor: Theme.of(context)
          .colorScheme
          .background
          .withOpacity(Theme.of(context).colorScheme.brightness == Brightness.dark ? 0.25 : 1),
    );
  }
}
