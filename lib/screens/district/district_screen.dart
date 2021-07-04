import 'package:cambodia_geography/models/tb_district_model.dart';
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
      body: CustomScrollView(
        slivers: [
          MorphingSliverAppBar(
            centerTitle: false,
            title: Text(
              district.khmer.toString(),
              key: Key("DistrictTitle"),
              style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
