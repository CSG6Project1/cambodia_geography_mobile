import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: CgAppBarTitle(title: "Place Detail"),
      ),
    );
  }
}
