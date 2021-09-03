import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
export 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreenSetting {
  final LatLng? initialLatLng;
  final MapFlowType flowType;
  final String? provinceCode;

  static LatLng defaultLatLng = LatLng(11.5564, 104.9282);

  MapScreenSetting({
    required this.flowType,
    this.initialLatLng,
    this.provinceCode,
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

class _MapScreenState extends State<MapScreen> {
  late final Completer<GoogleMapController> controller;
  late final CameraPosition cameraPosition;

  @override
  void initState() {
    controller = Completer();
    cameraPosition = CameraPosition(
      target: widget.settings.initialLatLng ?? MapScreenSetting.defaultLatLng,
      zoom: 14.4746,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController _controller) {
          controller.complete(_controller);
        },
      ),
    );
  }
}

// class _MapScreenState1 extends State<MapScreen> with CgThemeMixin, CgMediaQueryMixin {
//   late ValueNotifier<bool> expandedFilterNotifier;
//   late MapController controller;
//   late BasePlacesApi placesApi;

//   PlaceListModel? placeList;

//   static const double initialZoom = 8.0; //max 19
//   static const double provinceLevelZoom = 8.0; //max 19

//   List<Marker> markers = [];

//   LatLng? get currentLatLng {
//     if (markers.isEmpty) return null;
//     return markers.first.point;
//   }

//   late TextEditingController latitudeController;
//   late TextEditingController longitudeController;

//   @override
//   void initState() {
//     controller = MapController();
//     placesApi = PlacesApi();
//     expandedFilterNotifier = ValueNotifier(false);
//     if (widget.settings.initialLatLng != null) {
//       markers = [
//         buildMarker(widget.settings.initialLatLng!),
//       ];
//     }
//     latitudeController = TextEditingController(text: currentLatLng?.latitude.toString());
//     longitudeController = TextEditingController(text: currentLatLng?.longitude.toString());
//     super.initState();

//     if (widget.settings.provinceCode != null) load();
//   }

//   @override
//   void dispose() {
//     expandedFilterNotifier.dispose();
//     latitudeController.dispose();
//     longitudeController.dispose();
//     super.dispose();
//   }

//   Future<void> load({bool loadMore = false}) async {
//     if (loadMore && !(this.placeList?.hasLoadMore() == true)) return;
//     String? page = loadMore ? placeList?.links?.getPageNumber().next.toString() : null;

//     final result = await placesApi.fetchAllPlaces(
//       provinceCode: widget.settings.provinceCode,
//       page: page,
//     );

//     if (placesApi.success() && result != null) {
//       if (placeList != null && loadMore) {
//         placeList?.add(result);
//       } else {
//         placeList = result;
//       }

//       result as PlaceListModel;
//       Iterable<Marker>? markers = result.items?.where((e) => AppHelper.isLatLngValdated(e.lat, e.lon)).map((e) {
//         return Marker(
//           point: LatLng(e.lat!, e.lat!),
//           height: ConfigConstant.objectHeight6,
//           width: ConfigConstant.objectHeight6,
//           rotate: true,
//           builder: (context) {
//             return Container(
//               color: Colors.red,
//               height: ConfigConstant.objectHeight6,
//               width: ConfigConstant.objectHeight6,
//               child: CgNetworkImageLoader(
//                 imageUrl: e.images?.isNotEmpty == true ? e.images?.first.url : null,
//                 height: ConfigConstant.objectHeight6,
//                 width: ConfigConstant.objectHeight6,
//               ),
//             );
//           },
//         );
//       });

//       if (markers != null) {
//         setAMarker(markers.first.point);
//       }
//     }
//   }

//   void setAMarker(LatLng? latLng) {
//     setState(() {
//       markers = latLng != null ? [buildMarker(latLng)] : [];
//       latitudeController.text = currentLatLng?.latitude.toString() ?? "";
//       longitudeController.text = currentLatLng?.longitude.toString() ?? "";
//     });
//   }

//   void _moveToInitPosition() {
//     if (widget.settings.initialLatLng == null) return;
//     _moveToAPosition(widget.settings.initialLatLng!);
//   }

//   void _moveToAPosition(LatLng? latLng, {double zoom = initialZoom}) {
//     controller.move(latLng ?? MapScreenSetting.defaultLatLng, zoom);
//     controller.rotate(0);
//   }

//   LatLng? getLatLngFromCurrentTextFields() {
//     double? lat = double.tryParse(latitudeController.text);
//     double? lng = double.tryParse(longitudeController.text);
//     if (lat == null || lng == null) return null;
//     return LatLng(lat, lng);
//   }

//   void onProvinceChange(String? value) {
//     List<Object> provinces = CambodiaGeography.instance.tbProvinces.where((e) => e.khmer == value).toList();
//     if (provinces.isEmpty) return;
//     final province = provinces.first;
//     if (province is TbProvinceModel) {
//       latitudeController.text = province.latitude.toString();
//       longitudeController.text = province.longitudes.toString();
//       LatLng? latLng = getLatLngFromCurrentTextFields();
//       if (latLng == null) return;
//       _moveToAPosition(latLng, zoom: provinceLevelZoom);
//       setAMarker(latLng);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildAppBar(),
//       body: FlutterMap(
//         mapController: controller,
//         layers: buildLayers(),
//         options: buildOptions(),
//         nonRotatedChildren: buildNonRotatedChildren(),
//       ),
//     );
//   }

//   MorphingAppBar buildAppBar() {
//     return MorphingAppBar(
//       elevation: 0.0,
//       backgroundColor: colorScheme.secondary,
//       title: const CgAppBarTitle(title: "Map"),
//       actions: [
//         if (widget.settings.initialLatLng != null)
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () => _moveToInitPosition(),
//           ),
//       ],
//     );
//   }

//   List<LayerOptions> buildLayers() {
//     return [
//       TileLayerOptions(
//         urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//         subdomains: ['a', 'b', 'c'],
//         maxZoom: 13,
//         maxNativeZoom: 13,
//       ),
//       MarkerLayerOptions(markers: markers),
//     ];
//   }

//   MapOptions buildOptions() {
//     return MapOptions(
//       center: widget.settings.initialLatLng ?? MapScreenSetting.defaultLatLng,
//       zoom: initialZoom,
//       onTap: (LatLng latLng) {
//         if (widget.settings.flowType == MapFlowType.pick) {
//           setAMarker(latLng);
//         }
//       },
//     );
//   }

//   List<Widget> buildNonRotatedChildren() {
//     return [
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           PlaceInfoField(
//             widget: widget,
//             expandedFilterNotifier: expandedFilterNotifier,
//             onProvinceChange: onProvinceChange,
//             markers: markers,
//             latitudeController: latitudeController,
//             longitudeController: longitudeController,
//             currentLatLng: currentLatLng,
//             onApply: () {
//               LatLng? latLng = getLatLngFromCurrentTextFields();
//               if (latLng == null) return;
//               _moveToAPosition(latLng, zoom: provinceLevelZoom);
//               setAMarker(latLng);
//             },
//             onDone: () {
//               Navigator.of(context).pop(currentLatLng);
//             },
//           ),
//           Container(
//             margin: const EdgeInsets.only(right: 8.0, top: 8.0),
//             alignment: Alignment.topRight,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 MapButton(
//                   icon: Icons.crop_rotate,
//                   onPressed: () {
//                     _moveToAPosition(currentLatLng, zoom: controller.zoom);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ];
//   }

//   Marker buildMarker(LatLng latLng) {
//     return Marker(
//       width: 200.0,
//       height: 200.0,
//       rotate: true,
//       point: latLng,
//       builder: (ctx) => AnimatedOpacity(
//         opacity: markers.first.point == latLng ? 1 : 0,
//         duration: const Duration(milliseconds: 350),
//         child: Container(
//           child: Icon(Icons.place, size: 48, color: colorScheme.primary),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: ThemeConstant.darkScheme.primary.withOpacity(0.1),
//           ),
//         ),
//       ),
//     );
//   }
// }
