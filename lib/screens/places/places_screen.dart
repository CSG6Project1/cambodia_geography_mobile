import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/screens/places/local_widgets/place_card.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
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
  Future<PlaceListModel>? placeList;

  @override
  void initState() {
    placesApi = PlacesApi();
    super.initState();
    controller = TabController(length: 2, vsync: this);
    if (widget.province.code != null) placeList = load(widget.province.code!);
  }

  Future<PlaceListModel> load(String code) async {
    return await placesApi.fetchAll(queryParameters: {'province_code': code});
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
          buildBody(),
          Text("Tab 2"),
        ],
      ),
    );
  }

  FutureBuilder<PlaceListModel> buildBody() {
    return FutureBuilder<PlaceListModel>(
      future: placeList,
      builder: (context, snapshot) {
        List<PlaceModel>? places = snapshot.data?.items;
        if (places == null) return buildLoadingShimmer();
        if (places.length == 0)
          return Center(
            child: Text('No Data'),
          );
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
          children: List.generate(
            places.length,
            (index) {
              PlaceModel place = places[index];
              return PlaceCard(place: place);
            },
          ),
        );
      },
    );
  }

  MorphingAppBar buildAppbar() {
    return MorphingAppBar(
      title: CgAppBarTitle(title: widget.province.khmer ?? ''),
      bottom: TabBar(
        controller: controller,
        tabs: [
          Tab(
            child: Text(
              "តំបន់ទេសចរណ៍",
              style: TextStyle(
                fontFamilyFallback: Theme.of(context).textTheme.bodyText1?.fontFamilyFallback,
              ),
            ),
          ),
          Tab(
            child: Text(
              "ភោជនីយ៍ដ្ឆាន៍",
              style: TextStyle(
                fontFamilyFallback: Theme.of(context).textTheme.bodyText1?.fontFamilyFallback,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadingShimmer() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
      children: List.generate(5, (index) => PlaceCard(isLoading: true)),
    );
  }
}
