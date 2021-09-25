import 'dart:async';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/helpers/app_helper.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/screens/places/local_widgets/place_card.dart';
import 'package:cambodia_geography/services/apis/places/base_places_api.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
export 'package:google_maps_flutter/google_maps_flutter.dart';

class CarouselPlaceList extends StatefulWidget {
  const CarouselPlaceList({
    Key? key,
    required this.initialPlace,
    required this.controller,
    required this.onPageChanged,
  }) : super(key: key);

  final Completer<GoogleMapController> controller;
  final Function(PlaceModel)? onPageChanged;
  final PlaceModel? initialPlace;

  @override
  _CarouselPlaceListState createState() => _CarouselPlaceListState();
}

class _CarouselPlaceListState extends State<CarouselPlaceList> {
  late final CarouselController carouselController;
  late final BasePlacesApi placesApi;
  PlaceListModel? placeList;

  late bool showCarousel;

  List<PlaceModel> get places {
    return this.placeList?.items?.where((element) {
          return AppHelper.isLatLngValdated(element.lat, element.lon);
        }).toList() ??
        [];
  }

  @override
  void initState() {
    showCarousel = false;
    carouselController = CarouselController();
    placesApi = PlacesApi();
    super.initState();

    load(initialPage: widget.initialPlace?.page).then((value) {
      int? page = placeList?.items?.indexWhere((element) => element.id == widget.initialPlace?.id);
      if (page != null) {
        carouselController.animateToPage(page).then((value) {
          setState(() => showCarousel = true);
        });
      }
    });
  }

  Future<void> load({String? initialPage, bool loadMore = false, bool reverseLoad = false}) async {
    print("ATTEM LOAD");

    bool hasLoadMore = this.placeList?.hasLoadMore() == true || reverseLoad;
    if ((loadMore && !hasLoadMore)) return;
    String? page = initialPage ?? (loadMore ? placeList?.links?.getPageNumber().next.toString() : null);

    final result = await placesApi.fetchAllPlaces(
      type: widget.initialPlace?.placeType() != PlaceType.province ? widget.initialPlace?.placeType() : null,
      provinceCode: widget.initialPlace?.provinceCode,
      page: page,
    );

    if (placesApi.success() && result != null) {
      setState(() {
        if (placeList != null && loadMore) {
          placeList?.add(result, reverseLoad: reverseLoad);
        } else {
          placeList = result;
        }
      });

      if (reverseLoad && result?.items?.length != null) {
        carouselController.jumpToPage(result!.items!.length + 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: AnimatedCrossFade(
        crossFadeState: showCarousel ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: ConfigConstant.duration,
        secondChild: SizedBox(width: double.infinity),
        sizeCurve: Curves.ease,
        alignment: Alignment.bottomCenter,
        firstChild: CarouselSlider.builder(
          carouselController: carouselController,
          itemCount: this.placeList?.items?.length ?? 0,
          options: CarouselOptions(
            height: ConfigConstant.objectHeight6 + ConfigConstant.margin2,
            viewportFraction: 0.8,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              var self = placeList?.links?.getPageNumber().self;
              int selfInt = int.tryParse("$self") ?? 1;

              if (index == places.length - 2) {
                load(loadMore: true);
              } else if (index == 1 && selfInt > 1) {
                load(reverseLoad: true, loadMore: true, initialPage: "${selfInt - 1}");
              }

              PlaceModel place = this.places[index];
              if (widget.onPageChanged != null) {
                widget.onPageChanged!(place);
              }
            },
          ),
          itemBuilder: (BuildContext context, int index, int pageViewIndex) {
            PlaceModel? place = this.placeList?.items?[index];
            return buildPlaceItem(place, context, index);
          },
        ),
      ),
    );
  }

  Widget buildPlaceItem(PlaceModel? place, BuildContext context, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin0),
            child: Column(
              children: [
                PlaceCard(
                  place: place,
                  onTap: () {
                    if (place != null) {
                      Navigator.of(context).pushNamed(
                        RouteConfig.PLACEDETAIL,
                        arguments: place,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: ConfigConstant.fadeDuration,
          crossFadeState: this.placeList?.hasLoadMore() == true && index == places.length - 1
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Container(
            width: kToolbarHeight,
            margin: const EdgeInsets.only(left: ConfigConstant.margin1),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
          secondChild: const SizedBox(),
        ),
      ],
    );
  }
}
