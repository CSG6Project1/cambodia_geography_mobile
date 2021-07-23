import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:cambodia_geography/widgets/cg_custom_shimmer.dart';
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
              return buildPlaceCard(place);
            },
          ),
        );
      },
    );
  }

  Card buildPlaceCard(PlaceModel place) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: ConfigConstant.margin2,
        vertical: ConfigConstant.margin1,
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 2 / 1,
            child: Container(
              child: place.images == null || place.images?.length == 0
                  ? Image.asset('assets/images/helper_image/placeholder.png')
                  : Image.network(
                      place.images![0].url ?? '',
                      fit: BoxFit.cover,
                      height: ConfigConstant.objectHeight1,
                    ),
            ),
          ),
          const Divider(height: 0, thickness: 0.5),
          Container(
            color: colorScheme.surface,
            height: ConfigConstant.objectHeight1,
            padding: EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    place.khmer.toString(),
                    style: textTheme.bodyText1,
                  ),
                ),
                Text(
                  (place.commentLength ?? 0).toString(),
                  style: textTheme.caption,
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.mode_comment,
                  size: ConfigConstant.iconSize1,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
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
      children: List.generate(
        5,
        (index) {
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: ConfigConstant.margin2,
              vertical: ConfigConstant.margin1,
            ),
            child: Column(
              children: [
                CgCustomShimmer(
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: Container(
                      color: colorScheme.surface,
                    ),
                  ),
                ),
                const Divider(height: 0),
                Container(
                  color: colorScheme.surface,
                  height: ConfigConstant.objectHeight1,
                  padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CgCustomShimmer(
                        child: Container(height: 14, width: 200, color: colorScheme.surface),
                      ),
                      CgCustomShimmer(
                        child: Container(height: 14, width: 20, color: colorScheme.surface),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
