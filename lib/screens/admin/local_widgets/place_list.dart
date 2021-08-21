import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/places/local_widgets/place_card.dart';
import 'package:cambodia_geography/services/apis/admins/crud_places_api.dart';
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
    this.showDeleteButton = false,
    this.type,
  }) : super(key: key);

  final String provinceCode;
  final PlaceType? type;
  final void Function(PlaceModel place) onTap;
  final bool showDeleteButton;

  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> with AutomaticKeepAliveClientMixin, CgThemeMixin {
  late PlacesApi placesApi;
  late bool loading;

  String? provinceCode;
  PlaceListModel? placeList;

  @override
  void initState() {
    placesApi = PlacesApi();
    provinceCode = widget.provinceCode;
    super.initState();
    loading = true;
    if (provinceCode != null) load();
  }

  Future<void> load({bool loadMore = false}) async {
    if (loadMore && !(this.placeList?.hasLoadMore() == true)) return;

    final result = await placesApi.fetchAll(queryParameters: {
      'province_code': provinceCode,
      'type': widget.type == null ? null : widget.type.toString().replaceAll("PlaceType.", ""),
      'page': loadMore ? placeList?.links?.getPageNumber().next.toString() : null,
    });

    if (placesApi.success() && result != null) {
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

    return RefreshIndicator(
      onRefresh: () async => load(),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
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
              ),
              buildNoData(places, constraint.maxHeight)
            ],
          );
        },
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

  Widget buildNoData(List<PlaceModel>? places, double heigth) {
    return Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      left: 0,
      child: IgnorePointer(
        ignoring: !loading && places != null && places.isEmpty ? false : true,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: AnimatedOpacity(
            duration: ConfigConstant.duration,
            opacity: !loading && places != null && places.isEmpty ? 1 : 0,
            child: Container(
              height: heigth,
              color: colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: ConfigConstant.iconSize5,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: ConfigConstant.margin1),
                  Text("មិនមានទិន្នន័យ"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
