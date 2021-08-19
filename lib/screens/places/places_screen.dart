import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/screens/places/local_widgets/place_card.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:cambodia_geography/widgets/cg_load_more_list.dart';
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
  PlaceListModel? placeList;

  @override
  void initState() {
    placesApi = PlacesApi();
    controller = TabController(length: 2, vsync: this);
    provinceCode = widget.province.code;
    super.initState();
    if (provinceCode != null) load();
  }

  Future<void> load({bool loadMore = false}) async {
    if (loadMore && !(this.placeList?.hasLoadMore() == true)) return;

    final result = await placesApi.fetchAll(queryParameters: {
      'province_code': provinceCode,
      'page': placeList?.links?.getPageNumber().next.toString(),
    });

    if (placesApi.success() && result != null) {
      setState(() {
        if (placeList != null) {
          placeList?.add(result);
        } else {
          placeList = result;
        }
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<PlaceModel>? places = placeList?.items?.where((place) => place.type == 'place').toList();
    List<PlaceModel>? restaurant = placeList?.items?.where((place) => place.type == 'restaurant').toList();
    return Scaffold(
      appBar: buildAppbar(),
      body: TabBarView(
        controller: controller,
        children: [
          buildBody(places: places),
          buildBody(places: restaurant),
        ],
      ),
    );
  }

  Widget buildBody({required List<PlaceModel>? places}) {
    if (places == null) return buildLoadingShimmer();
    return CgLoadMoreList(
      onEndScroll: () => load(loadMore: true),
      child: ListView.builder(
        itemCount: places.length + 1,
        itemBuilder: (context, index) {
          if (places.length == index) {
            return Visibility(
              visible: placeList?.hasLoadMore() == true,
              child: Container(
                alignment: Alignment.center,
                padding: ConfigConstant.layoutPadding,
                child: const CircularProgressIndicator(),
              ),
            );
          }
          return PlaceCard(
            place: places[index],
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteConfig.PLACEDETAIL,
                arguments: places[index],
              );
            },
          );
        },
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
              "ភោជនីយដ្ឋាន",
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
        (index) => PlaceCard(
          isLoading: true,
          onTap: () {},
        ),
      ),
    );
  }
}
