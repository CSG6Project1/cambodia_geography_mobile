import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
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
      body: CustomScrollView(
        slivers: [
          buildAppbar(),
          FutureBuilder<PlaceListModel>(
            future: placeList,
            builder: (context, snapshot) {
              List<PlaceModel>? places = snapshot.data?.items;
              if (places == null)
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [Text('')],
                  ),
                );
              return SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(
                    places.length,
                    (index) {
                      PlaceModel place = places[index];
                      return buildPlaceCard(place);
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Card buildPlaceCard(PlaceModel place) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: ConfigConstant.margin2,
        vertical: ConfigConstant.margin1,
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 2 / 1,
            child: Image.network(
              place.images?[0] ?? '',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.white,
            height: ConfigConstant.objectHeight1,
            padding: EdgeInsets.symmetric(horizontal: ConfigConstant.margin1),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    place.khmer.toString(),
                    style: textTheme.bodyText1,
                  ),
                ),
                Text(
                  place.commentLength.toString(),
                  style: textTheme.caption,
                ),
                SizedBox(width: 5),
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

  MorphingSliverAppBar buildAppbar() {
    return MorphingSliverAppBar(
      floating: true,
      pinned: true,
      forceElevated: true,
      title: CgAppBarTitle(title: widget.province.khmer ?? ''),
      bottom: TabBar(
        controller: controller,
        tabs: [
          Tab(
            child: Text("តំបន់ទេសចរណ៍"),
          ),
          Tab(
            child: Text("ភោជនីយ៍ដ្ឆាន៍"),
          ),
        ],
      ),
    );
  }
}
