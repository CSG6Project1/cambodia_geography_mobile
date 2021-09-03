import 'dart:async';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/helpers/app_helper.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
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
    required this.initialPage,
    required this.controller,
    required this.onPageChanged,
  }) : super(key: key);

  final Completer<GoogleMapController> controller;
  final Function(PlaceModel)? onPageChanged;
  final PlaceModel? initialPlace;
  final String? initialPage;

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

    load(initialPage: widget.initialPage).then((value) {
      int? page = placeList?.items?.indexWhere((element) => element.id == widget.initialPlace?.id);
      if (page != null) {
        carouselController.animateToPage(page).then((value) {
          setState(() => showCarousel = true);
        });
      }
    });
  }

  Future<void> load({String? initialPage, bool loadMore = false}) async {
    if (loadMore && !(this.placeList?.hasLoadMore() == true)) return;
    String? page = initialPage ?? (loadMore ? placeList?.links?.getPageNumber().next.toString() : null);

    final result = await placesApi.fetchAllPlaces(
      provinceCode: widget.initialPlace?.provinceCode,
      page: page,
      type: widget.initialPlace?.placeType(),
    );

    if (placesApi.success() && result != null) {
      setState(() {
        if (placeList != null && loadMore) {
          placeList?.add(result);
        } else {
          placeList = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
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
              PlaceModel place = this.places[index];
              if (widget.onPageChanged != null) {
                widget.onPageChanged!(place);
              }
            },
          ),
          itemBuilder: (BuildContext context, int index, int pageViewIndex) {
            PlaceModel? place = this.placeList?.items?[index];
            return buildPlaceItem(place, context);
          },
        ),
      ),
    );
  }

  Column buildPlaceItem(PlaceModel? place, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin0),
          child: PlaceCard(
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
        ),
      ],
    );
  }
}
