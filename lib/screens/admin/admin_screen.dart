import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/screens/drawer/app_drawer.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  String? currentProvinceCode;
  late TabController controller;
  late CambodiaGeography geo;

  @override
  void initState() {
    geo = CambodiaGeography.instance;
    currentProvinceCode = geo.tbProvinces[0].code;
    controller = TabController(length: geo.tbProvinces.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
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
      title: CgAppBarTitle(title: "Admin"),
      leading: Builder(builder: (context) {
        return IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
      bottom: TabBar(
        key: const Key("HomeTabBar"),
        controller: controller,
        isScrollable: true,
        tabs: List.generate(
          geo.tbProvinces.length,
          (index) => Tab(
            key: Key("HomeTabItem$index"),
            child: Text(
              geo.tbProvinces[index].khmer.toString(),
            ),
          ),
        ),
      ),
    );
  }
}
