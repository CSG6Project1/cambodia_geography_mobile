import 'dart:async';
import 'package:cambodia_geography/constants/api_constant.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/helpers/app_helper.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/map/local_widgets/carousel_place_list.dart';
import 'package:cambodia_geography/widgets/cg_bottom_nav_wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
export 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class MapScreenSetting {
  final LatLng? initialLatLng;
  final MapFlowType flowType;
  final PlaceModel? place;
  final String? initialSearchKeyword;

  static LatLng defaultLatLng = LatLng(11.5564, 104.9282);

  MapScreenSetting({
    required this.flowType,
    this.initialLatLng,
    this.place,
    this.initialSearchKeyword,
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
  late final ValueNotifier<String?> currentNameNotifier;

  Set<Marker> markers = {};
  bool get picking => widget.settings.flowType == MapFlowType.pick;

  @override
  void initState() {
    controller = Completer();
    currentNameNotifier = ValueNotifier(null);
    cameraPosition = CameraPosition(
      target: widget.settings.initialLatLng ?? MapScreenSetting.defaultLatLng,
      zoom: 12,
    );

    if (widget.settings.initialLatLng != null) {
      setMarker(widget.settings.initialLatLng!);
    } else if (widget.settings.initialSearchKeyword != null) {
      Future.delayed(ConfigConstant.duration).then((e) {
        openPlacesAutocomplete(initialKeyword: widget.settings.initialSearchKeyword);
      });
    }

    super.initState();
  }

  Marker buildPinMarker(LatLng latLng) {
    return Marker(
      position: latLng,
      markerId: MarkerId(latLng.toString()),
      infoWindow: InfoWindow(title: widget.settings.place?.nameTr),
    );
  }

  void addToMarker(LatLng latLng, PlaceModel? place) {
    Marker marker = Marker(markerId: MarkerId(latLng.toString()));
    setState(() {
      this.markers.add(marker);
    });
  }

  void moveCameraTo(LatLng latLng) async {
    print(latLng.toJson().toString());
    GoogleMapController _mapController = await controller.future;
    _mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  void setMarker(LatLng latLng, {bool updateState = true}) {
    Marker marker = buildPinMarker(latLng);

    if (updateState) {
      setState(() => this.markers = Set.of([marker]));
    } else {
      this.markers = Set.of([marker]);
    }

    this.currentNameNotifier.value = null;
    placemarkFromCoordinates(latLng.latitude, latLng.longitude).then((placemarks) {
      this.currentNameNotifier.value = [
        tr('msg.geo.latlng', namedArgs: {
          'LATLNG': latLng.latitude.toString(),
        }),
        latLng.longitude,
        placemarks.first.toJson().values.map((e) => e),
      ].join(", ");
    });
  }

  void onCarouselPageChanged(PlaceModel place) async {
    setMarker(place.latLng()!);
    moveCameraTo(LatLng(place.lat!, place.lon!));
  }

  @override
  void dispose() {
    currentNameNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      bottomNavigationBar: buildBottomNavigationBar(),
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
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
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
            onTap: (LatLng latLng) async {
              if (!picking) return;
              setMarker(latLng);
            },
            onLongPress: (LatLng latLng) {},
          ),
          if (widget.settings.flowType == MapFlowType.view)
            Container(
              margin: const EdgeInsets.only(top: ConfigConstant.margin2),
              child: CarouselPlaceList(
                initialPlace: widget.settings.place,
                controller: controller,
                onPageChanged: onCarouselPageChanged,
              ),
            )
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    if (widget.settings.flowType != MapFlowType.pick) return SizedBox();
    return CgBottomNavWrapper(
      child: Column(
        children: [
          ValueListenableBuilder<String?>(
            valueListenable: currentNameNotifier,
            builder: (context, value, child) {
              return AnimatedCrossFade(
                crossFadeState: value?.isNotEmpty == true ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: ConfigConstant.fadeDuration,
                secondChild: SizedBox(width: double.infinity),
                firstChild: Container(
                  width: double.infinity,
                  child: Text(value ?? "", textAlign: TextAlign.start),
                ),
              );
            },
          ),
          Container(
            width: double.infinity,
            child: CgButton(
              labelText: tr('button.confirm'),
              foregroundColor: colorScheme.onPrimary,
              onPressed: () {
                if (this.markers.isEmpty) return;
                Navigator.of(context).pop(this.markers.first.position);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<LatLng?> getLatLng(Prediction? prediction) async {
    if (prediction?.placeId != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: ApiConstant.googleMapApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(prediction!.placeId!);
      double? lat = detail.result.geometry?.location.lat;
      double? lng = detail.result.geometry?.location.lng;
      if (AppHelper.isLatLngValdated(lat, lng)) {
        return LatLng(lat!, lng!);
      }
    }
  }

  Future<void> openPlacesAutocomplete({String? initialKeyword}) async {
    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: ApiConstant.googleMapApiKey,
      mode: Mode.overlay, // Mode.fullscreen
      types: [],
      strictbounds: false,
      components: [],
      startText: initialKeyword ?? "",
    );
    LatLng? latLng = await getLatLng(prediction);
    if (latLng != null) {
      setMarker(latLng);
      moveCameraTo(latLng);
    }
  }

  MorphingAppBar buildAppBar() {
    return MorphingAppBar(
      elevation: 0.0,
      backgroundColor: colorScheme.surface,
      leading: BackButton(color: Theme.of(context).colorScheme.primary),
      title: picking
          ? TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: tr('hint.search_for_places'),
                border: InputBorder.none,
              ),
              onTap: () async {
                await openPlacesAutocomplete();
              },
            )
          : CgAppBarTitle(
              title: tr('button.map'),
              textStyle: TextStyle(color: colorScheme.onSurface),
            ),
      actions: [],
    );
  }
}
