import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:cambodia_geography/widgets/cg_gps_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({
    required this.province,
    Key? key,
  }) : super(key: key);

  final TbProvinceModel province;

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> with SingleTickerProviderStateMixin, CgThemeMixin {
  late TabController controller;
  late PlacesApi placesApi;
  String? provinceCode;

  @override
  void initState() {
    placesApi = PlacesApi();
    controller = TabController(length: 2, vsync: this);
    provinceCode = widget.province.code;
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
      appBar: buildAppbar(),
      body: TabBarView(
        controller: controller,
        children: [
          PlaceList(
            provinceCode: provinceCode!,
            type: PlaceType.place,
            basePlacesApi: PlacesApi(),
            onTap: (place) {
              Navigator.of(context).pushNamed(
                RouteConfig.PLACEDETAIL,
                arguments: place,
              );
            },
          ),
          PlaceList(
            provinceCode: provinceCode!,
            type: PlaceType.restaurant,
            basePlacesApi: PlacesApi(),
            onTap: (place) {
              Navigator.of(context).pushNamed(
                RouteConfig.PLACEDETAIL,
                arguments: place,
              );
            },
          ),
        ],
      ),
    );
  }

  MorphingAppBar buildAppbar() {
    return MorphingAppBar(
      title: CgAppBarTitle(title: widget.province.nameTr ?? ''),
      actions: [
        CgGpsButton(),
      ],
      bottom: TabBar(
        controller: controller,
        tabs: [
          Tab(
            child: Text(
              tr('place_type.place'),
              style: TextStyle(
                fontFamilyFallback: Theme.of(context).textTheme.bodyText1?.fontFamilyFallback,
              ),
            ),
          ),
          Tab(
            child: Text(
              tr('place_type.restaurant'),
              style: TextStyle(
                fontFamilyFallback: Theme.of(context).textTheme.bodyText1?.fontFamilyFallback,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
