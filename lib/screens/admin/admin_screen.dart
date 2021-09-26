import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/providers/editing_provider.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:cambodia_geography/widgets/cg_gps_button.dart';
import 'package:cambodia_geography/widgets/cg_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
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
    return CgScaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(RouteConfig.EDIT_PLACE).then((value) {
            if (value is PlaceModel) {
              Fluttertoast.showToast(msg: 'Created place successfully');
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
            String code = geo.tbProvinces[index].code ?? "";
            return PlaceList(
              provinceCode: code,
              showDeleteButton: true,
              basePlacesApi: PlacesApi(),
              onTap: (place) {
                Navigator.of(context).pushNamed(
                  RouteConfig.EDIT_PLACE,
                  arguments: place,
                );
              },
            );
          },
        ),
      ),
    );
  }

  MorphingAppBar buildAppbar() {
    return MorphingAppBar(
      title: CgAppBarTitle(title: "Admin"),
      actions: [
        CgGpsButton(),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            EditingProvider provider = Provider.of<EditingProvider>(context, listen: false);
            provider.editing = !provider.editing;
          },
        ),
      ],
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
              geo.tbProvinces[index].nameTr.toString(),
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
