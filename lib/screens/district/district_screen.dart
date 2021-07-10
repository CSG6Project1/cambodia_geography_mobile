import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class DistrictScreen extends StatelessWidget {
  const DistrictScreen({
    Key? key,
    required this.district,
  }) : super(key: key);

  final TbDistrictModel district;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          MorphingSliverAppBar(
            forceElevated: true,
            title: CGAppBarTitle(title: district.khmer.toString()),
          ),
        ],
      ),
    );
  }
}
