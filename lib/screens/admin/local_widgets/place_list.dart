import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/places/local_widgets/place_card.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:cambodia_geography/widgets/cg_load_more_list.dart';
import 'package:flutter/material.dart';

class PlaceList extends StatefulWidget {
  const PlaceList({Key? key, required this.provinceCode}) : super(key: key);

  final String provinceCode;

  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  late PlacesApi placesApi;
  String? provinceCode;
  PlaceListModel? placeList;

  @override
  void initState() {
    placesApi = PlacesApi();
    provinceCode = widget.provinceCode;
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
  Widget build(BuildContext context) {
    List<PlaceModel>? places = placeList?.items?.where((place) => place.type == 'place').toList();
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
                RouteConfig.EDIT_PLACE,
                arguments: places[index],
              );
            },
          );
        },
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
