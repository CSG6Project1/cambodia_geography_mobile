import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/theme_constant.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:cambodia_geography/widgets/cg_button.dart';
import 'package:cambodia_geography/widgets/cg_dropdown_field.dart';
import 'package:cambodia_geography/widgets/cg_text_field.dart';
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

class _MapScreenState extends State<MapScreen> with CgThemeMixin, CgMediaQueryMixin {
  late ValueNotifier<bool> expandedFilterNotifier;
  late MapController controller;
  static const double initialZoom = 13.0; //max 19
  static const double provinceLevelZoom = 8.0; //max 19

  List<Marker> markers = [];

  LatLng? get currentLatLng {
    if (markers.isEmpty) return null;
    return markers.first.point;
  }

  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  @override
  void initState() {
    controller = MapController();
    expandedFilterNotifier = ValueNotifier(false);
    if (widget.settings.initialLatLng != null) {
      markers = [
        buildMarker(widget.settings.initialLatLng!),
      ];
    }
    latitudeController = TextEditingController(text: currentLatLng?.latitude.toString());
    longitudeController = TextEditingController(text: currentLatLng?.longitude.toString());
    super.initState();
  }

  @override
  void dispose() {
    expandedFilterNotifier.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  void setAMarker(LatLng? latLng) {
    setState(() {
      markers = latLng != null ? [buildMarker(latLng)] : [];
      latitudeController.text = currentLatLng?.latitude.toString() ?? "";
      longitudeController.text = currentLatLng?.longitude.toString() ?? "";
    });
  }

  void _moveToInitPosition() {
    if (widget.settings.initialLatLng == null) return;
    _moveToAPosition(widget.settings.initialLatLng!);
  }

  void _moveToAPosition(LatLng? latLng, {double zoom = initialZoom}) {
    controller.move(latLng ?? MapScreenSetting.defaultLatLng, zoom);
    controller.rotate(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: FlutterMap(
        mapController: controller,
        layers: buildLayers(),
        options: buildOptions(),
        nonRotatedChildren: buildNonRotatedChildren(),
      ),
    );
  }

  MorphingAppBar buildAppBar() {
    return MorphingAppBar(
      elevation: 0.0,
      backgroundColor: colorScheme.secondary,
      title: const CGAppBarTitle(title: "Map"),
      actions: [
        if (widget.settings.initialLatLng != null)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _moveToInitPosition(),
          ),
      ],
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

  MapOptions buildOptions() {
    return MapOptions(
      center: widget.settings.initialLatLng ?? MapScreenSetting.defaultLatLng,
      zoom: initialZoom,
      onTap: (LatLng latLng) {
        if (widget.settings.flowType == MapFlowType.pick) {
          setAMarker(latLng);
        }
      },
    );
  }

  List<Widget> buildNonRotatedChildren() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildPlaceInfoFields(),
          Container(
            margin: const EdgeInsets.only(right: 8.0, top: 8.0),
            alignment: Alignment.topRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildMapButton(
                  icon: Icons.crop_rotate,
                  onPressed: () {
                    _moveToAPosition(currentLatLng, zoom: controller.zoom);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  Widget buildPlaceInfoFields() {
    if (widget.settings.flowType != MapFlowType.pick) return SizedBox();
    return ValueListenableBuilder<bool>(
      valueListenable: expandedFilterNotifier,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildProvinceDropDown(),
          const SizedBox(height: 8.0),
          buildLatLngField(),
          const SizedBox(height: 16.0),
          buildActionButtons()
        ],
      ),
      builder: (context, value, child) {
        return ExpansionTile(
          initiallyExpanded: true,
          backgroundColor: colorScheme.surface,
          collapsedBackgroundColor: colorScheme.surface,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: [child ?? const SizedBox()],
          onExpansionChanged: (bool expanded) {
            expandedFilterNotifier.value = expanded;
          },
          title: Text(
            "Filter",
            style: textTheme.bodyText1?.copyWith(
              color: expandedFilterNotifier.value ? colorScheme.onSurface : null,
            ),
          ),
        );
      },
    );
  }

  LatLng? getLatLngFromCurrentTextFields() {
    double? lat = double.tryParse(latitudeController.text);
    double? lng = double.tryParse(longitudeController.text);
    if (lat == null || lng == null) return null;
    return LatLng(lat, lng);
  }

  Widget buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CgButton(
            labelText: "Apply",
            iconData: Icons.map,
            backgroundColor: colorScheme.onBackground,
            foregroundColor: colorScheme.background,
            onPressed: currentLatLng != null
                ? () {
                    LatLng? latLng = getLatLngFromCurrentTextFields();
                    if (latLng == null) return;
                    _moveToAPosition(latLng, zoom: provinceLevelZoom);
                    setAMarker(latLng);
                  }
                : null,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: CgButton(
            labelText: "Done",
            iconData: Icons.check,
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            onPressed: currentLatLng != null ? () => Navigator.of(context).pop(currentLatLng) : null,
          ),
        ),
      ],
    );
  }

  Widget buildProvinceDropDown() {
    return CgDropDownField(
      items: List.generate(
        CambodiaGeography.instance.tbProvinces.length,
        (index) {
          return CambodiaGeography.instance.tbProvinces[index].khmer ?? "";
        },
      ),
      onChanged: (String? value) {
        List<Object> provinces = CambodiaGeography.instance.tbProvinces.where((e) => e.khmer == value).toList();
        if (provinces.isEmpty) return;
        final province = provinces.first;
        if (province is TbProvinceModel) {
          latitudeController.text = province.latitude.toString();
          longitudeController.text = province.longitudes.toString();
          LatLng? latLng = getLatLngFromCurrentTextFields();
          if (latLng == null) return;
          _moveToAPosition(latLng, zoom: provinceLevelZoom);
          setAMarker(latLng);
        }
      },
    );
  }

  Widget buildLatLngField() {
    LatLng? latLng;
    if (markers.isNotEmpty) latLng = markers.first.point;
    return Row(
      children: [
        Expanded(
          child: CgTextField(
            labelText: "Latitude",
            value: latLng?.latitude.toString(),
            controller: latitudeController,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: CgTextField(
            labelText: "Longtitude",
            value: latLng?.longitude.toString(),
            controller: longitudeController,
          ),
        ),
      ],
    );
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
          child: Icon(Icons.place, size: 48, color: colorScheme.primary),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeConstant.darkScheme.primary.withOpacity(0.1),
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
