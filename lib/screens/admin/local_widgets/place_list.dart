import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/places/local_widgets/place_card.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:cambodia_geography/widgets/cg_load_more_list.dart';
import 'package:flutter/material.dart';

enum PlaceType {
  place,
  restaurant,
}

class PlaceList extends StatefulWidget {
  const PlaceList({
    Key? key,
    required this.provinceCode,
    required this.onTap,
    this.type,
  }) : super(key: key);

  final String provinceCode;
  final PlaceType? type;
  final void Function(PlaceModel place) onTap;

  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> with AutomaticKeepAliveClientMixin {
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
      'type': widget.type == null ? null : widget.type.toString().replaceAll("PlaceType.", ""),
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
    super.build(context);
    List<PlaceModel>? places = placeList?.items;
    return CgLoadMoreList(
      onEndScroll: () => load(loadMore: true),
      child: ListView.separated(
        padding: ConfigConstant.layoutPadding,
        itemCount: places == null ? 5 : places.length + 1,
        separatorBuilder: (context, index) {
          return SizedBox(height: ConfigConstant.margin1);
        },
        itemBuilder: (context, index) {
          if (places?.length == index) {
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
            place: places?[index],
            onTap: () {
              if (places?[index] == null) return;
              widget.onTap(places![index]);
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
