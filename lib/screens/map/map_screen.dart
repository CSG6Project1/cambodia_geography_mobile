import 'dart:async';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/map/local_widgets/carousel_place_list.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
export 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreenSetting {
  final LatLng? initialLatLng;
  final MapFlowType flowType;
  final PlaceModel? place;
  final String? page;

  static LatLng defaultLatLng = LatLng(11.5564, 104.9282);

  MapScreenSetting({
    required this.flowType,
    this.initialLatLng,
    this.place,
    this.page,
  });
}

enum MapFlowType {
  view,
  pick,
}

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
    required this.settings,
  }) : super(key: key);

  final MapScreenSetting settings;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with CgThemeMixin, CgMediaQueryMixin {
  late final Completer<GoogleMapController> controller;
  late final CameraPosition cameraPosition;

  Set<Marker> markers = {};

  @override
  void initState() {
    controller = Completer();
    cameraPosition = CameraPosition(
      target: widget.settings.initialLatLng ?? MapScreenSetting.defaultLatLng,
      zoom: 12,
    );

    if (widget.settings.initialLatLng != null) {
      markers.add(buildPinMarker(
        widget.settings.initialLatLng!,
      ));
    }

    super.initState();
  }

  Marker buildPinMarker(LatLng latLng) {
    return Marker(
      position: latLng,
      markerId: MarkerId(latLng.toString()),
      infoWindow: InfoWindow(title: widget.settings.place?.khmer),
    );
  }

  void addToMarker(LatLng latLng, PlaceModel? place) {
    Marker marker = Marker(markerId: MarkerId(latLng.toString()));
    setState(() {
      this.markers.add(marker);
    });
  }

  void onCarouselPageChanged(PlaceModel place) async {
    Marker marker = buildPinMarker(place.latLng()!);
    setState(() => this.markers = Set.of([marker]));
    GoogleMapController _mapController = await controller.future;
    _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
      place.lat!,
      place.lon!,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: cameraPosition,
            onMapCreated: (_controller) => controller.complete(_controller),
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            compassEnabled: true,
            mapToolbarEnabled: true,
            cameraTargetBounds: CameraTargetBounds.unbounded,
            mapType: MapType.normal,
            minMaxZoomPreference: MinMaxZoomPreference.unbounded,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            liteModeEnabled: false,
            tiltGesturesEnabled: true,
            myLocationEnabled: false,
            myLocationButtonEnabled: true,
            padding: const EdgeInsets.all(0),
            indoorViewEnabled: false,
            trafficEnabled: false,
            buildingsEnabled: false,
            markers: markers,
            polygons: const <Polygon>{},
            polylines: const <Polyline>{},
            circles: const <Circle>{},
            onCameraMoveStarted: () {},
            tileOverlays: const <TileOverlay>{},
            onCameraMove: (CameraPosition position) {},
            onCameraIdle: () {},
            onTap: (LatLng latLng) {},
            onLongPress: (LatLng latLng) {},
          ),
          CarouselPlaceList(
            initialPage: widget.settings.page,
            initialPlace: widget.settings.place,
            controller: controller,
            onPageChanged: onCarouselPageChanged,
          )
        ],
      ),
    );
  }

  MorphingAppBar buildAppBar() {
    return MorphingAppBar(
      elevation: 0.0,
      backgroundColor: colorScheme.surface,
      leading: BackButton(
        color: colorScheme.onSurface,
      ),
      title: CgAppBarTitle(
        title: "Map",
        textStyle: TextStyle(color: colorScheme.onSurface),
      ),
      actions: [],
    );
  }
}
