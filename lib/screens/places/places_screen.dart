import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildAppbar(),
        ],
      ),
    );
  }

  MorphingSliverAppBar buildAppbar() {
    return MorphingSliverAppBar(
      floating: true,
      pinned: true,
      forceElevated: true,
      title: CGAppBarTitle(title: "ខេត្តសៀមរៀប"),
      bottom: TabBar(
        controller: controller,
        tabs: List.generate(
          controller.length,
          (index) => Tab(
            child: Text("DATA"),
          ),
        ),
      ),
    );
  }
}
