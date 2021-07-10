import 'package:cambodia_geography/constants/theme_constant.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:latlong2/latlong.dart';
export 'package:latlong2/latlong.dart';

class MapScreenSetting {
  final LatLng? initialLatLng;
  final MapFlowType flowType;

  static LatLng defaultLatLng = LatLng(11.5564, 104.9282);

  MapScreenSetting({
    required this.flowType,
    this.initialLatLng,
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
  late MapController controller;
  late double initialZoom;

  List<Marker> markers = [];

  @override
  void initState() {
    controller = MapController();
    initialZoom = 13.0; //max 19
    if (widget.settings.initialLatLng != null) {
      markers = [buildMarker(widget.settings.initialLatLng!)];
    }
    super.initState();
  }

  void setAMarker(LatLng? latLng) {
    setState(() {
      markers = latLng != null ? [buildMarker(latLng)] : [];
    });
  }

  void moveToInitPosition() {
    if (widget.settings.initialLatLng == null) return;
    moveToAPosition(widget.settings.initialLatLng!);
  }

  void moveToAPosition(LatLng latLng) {
    controller.move(latLng, initialZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: const CGAppBarTitle(title: "Map"),
        actions: [
          if (widget.settings.flowType == MapFlowType.pick)
            TextButton(
              onPressed: () {
                controller.move(MapScreenSetting.defaultLatLng, initialZoom);
                setAMarker(null);
              },
              child: Text("Reset"),
            ),
        ],
      ),
      body: FlutterMap(
        mapController: controller,
        nonRotatedChildren: buildNonRotatedChildren(),
        layers: buildLayers(),
        options: MapOptions(
          center: widget.settings.initialLatLng ?? MapScreenSetting.defaultLatLng,
          zoom: initialZoom,
          onTap: (LatLng latLng) {
            if (widget.settings.flowType == MapFlowType.pick) {
              setAMarker(latLng);
            }
          },
        ),
      ),
    );
  }

  List<LayerOptions> buildLayers() {
    return [
      TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c'],
        maxZoom: 13,
        maxNativeZoom: 13,
      ),
      MarkerLayerOptions(markers: markers),
    ];
  }

  List<Widget> buildNonRotatedChildren() {
    return [
      if (widget.settings.initialLatLng != null)
        Positioned(
          top: 12,
          right: 12,
          child: buildMapButton(
            icon: Icons.place,
            onPressed: () => moveToInitPosition(),
          ),
        ),
    ];
  }

  Marker buildMarker(LatLng latLng) {
    return Marker(
      width: 200.0,
      height: 200.0,
      rotate: true,
      point: latLng,
      builder: (ctx) => AnimatedOpacity(
        opacity: markers.first.point == latLng ? 1 : 0,
        duration: const Duration(milliseconds: 350),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeConstant.darkScheme.primary.withOpacity(0.1),
          ),
          child: Icon(
            Icons.place,
            size: 48,
            color: ThemeConstant.darkScheme.primary,
          ),
        ),
      ),
    );
  }

  // inspire style by google map button
  Widget buildMapButton({
    required IconData icon,
    required void Function() onPressed,
  }) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 0,
            offset: Offset(0, 0.1),
          )
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Icon(icon, color: Colors.black.withOpacity(0.6), size: 16),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.8),
          primary: Colors.grey.withOpacity(0.2),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
