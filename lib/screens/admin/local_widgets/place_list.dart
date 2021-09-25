import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/places/local_widgets/place_card.dart';
import 'package:cambodia_geography/services/apis/admins/crud_places_api.dart';
import 'package:cambodia_geography/services/apis/places/base_places_api.dart';
import 'package:cambodia_geography/widgets/cg_load_more_list.dart';
import 'package:cambodia_geography/widgets/cg_no_data_wrapper.dart';
import 'package:flutter/material.dart';

enum PlaceType {
  place,
  restaurant,
  province,
  draft,
}

class PlaceList extends StatefulWidget {
  const PlaceList({
    Key? key,
    this.provinceCode,
    required this.onTap,
    this.showDeleteButton = false,
    this.type,
    this.keyword,
    this.districtCode,
    this.villageCode,
    this.communeCode,
    required this.basePlacesApi,
    this.page,
  }) : super(key: key);

  final void Function(PlaceModel place) onTap;
  final bool showDeleteButton;
  final BasePlacesApi basePlacesApi;
  final String? keyword;
  final PlaceType? type;
  final String? provinceCode;
  final String? districtCode;
  final String? villageCode;
  final String? communeCode;
  final String? page;

  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> with AutomaticKeepAliveClientMixin, CgThemeMixin {
  late BasePlacesApi placesApi;
  late bool loading;

  String? provinceCode;
  PlaceListModel? placeList;

  @override
  void initState() {
    placesApi = widget.basePlacesApi;
    provinceCode = widget.provinceCode;
    super.initState();
    loading = true;
    load();
  }

  Future<void> load({bool loadMore = false}) async {
    if (loadMore && !(this.placeList?.hasLoadMore() == true)) return;
    String? page = loadMore ? placeList?.links?.getPageNumber().next.toString() : null;

    final result = await placesApi.fetchAllPlaces(
      keyword: widget.keyword,
      type: widget.type,
      provinceCode: widget.provinceCode,
      districtCode: widget.districtCode,
      villageCode: widget.villageCode,
      communeCode: widget.communeCode,
      page: page,
    );

    if (placesApi.success() && result != null) {
      if (!mounted) return;
      setState(() {
        loading = false;
        if (placeList != null && loadMore) {
          placeList?.add(result);
        } else {
          placeList = result;
        }
      });
    }
  }

  Future<void> onDelete(PlaceModel? place) async {
    if (widget.showDeleteButton) {
      if (place?.id == null) return;

      OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: "Are you sure to delete this place?",
        message: place?.khmer ?? place?.khmer ?? "",
      );

      switch (result) {
        case OkCancelResult.ok:
          CrudPlacesApi api = CrudPlacesApi();
          App.of(context)?.showLoading();
          await api.deletePlace(id: place!.id!);

          if (api.success()) {
            await load();
            App.of(context)?.hideLoading();
          } else if (api.message() != null) {
            App.of(context)?.hideLoading();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(api.message() ?? ""),
              ),
            );
          } else {
            App.of(context)?.hideLoading();
          }
          break;
        case OkCancelResult.cancel:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<PlaceModel>? places = placeList?.items;
    bool empty = places != null && places.isEmpty || places == null;
    bool isNoData = !loading && empty;

    return RefreshIndicator(
      onRefresh: () async => load(),
      child: CgNoDataWrapper(
        child: CgLoadMoreList(
          onEndScroll: () => load(loadMore: true),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: ConfigConstant.layoutPadding,
            itemCount: places == null ? 5 : places.length + 1,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: ConfigConstant.margin1,
              );
            },
            itemBuilder: (context, index) {
              if (places?.length == index) return buildLoadMoreLoading();
              return PlaceCard(
                onDelete: () => onDelete(places?[index]),
                place: places?[index],
                onTap: () {
                  if (places?[index] == null) return;
                  widget.onTap(places![index]);
                },
              );
            },
          ),
        ),
        isNoData: isNoData,
      ),
    );
  }

  Visibility buildLoadMoreLoading() {
    return Visibility(
      visible: placeList?.hasLoadMore() == true,
      child: Container(
        alignment: Alignment.center,
        padding: ConfigConstant.layoutPadding,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
