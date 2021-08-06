import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/drawer/drawer_wrapper.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'local_widgets/place_list.dart';

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(RouteConfig.EDIT_PLACE).then((value) {
            if (value is PlaceModel) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Success created place: ${value.khmer ?? value.english}"),
                ),
              );
            }
          });
        },
      ),
      appBar: buildAppbar(),
      body: TabBarView(
        controller: controller,
        children: List.generate(
          controller.length,
          (index) {
            return PlaceList(provinceCode: geo.tbProvinces[index].code ?? "");
          },
        ),
      ),
    );
  }

  MorphingAppBar buildAppbar() {
    return MorphingAppBar(
      title: CgAppBarTitle(title: "Admin"),
      leading: Builder(builder: (context) {
        return IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            DrawerWrapper.of(context)?.open();
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
              style: TextStyle(
                fontFamilyFallback: Theme.of(context).textTheme.bodyText1?.fontFamilyFallback,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
