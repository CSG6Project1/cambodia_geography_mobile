import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/screens/map/map_screen.dart';

class PlaceInfoField extends StatefulWidget {
  const PlaceInfoField({
    Key? key,
    required this.widget,
    required this.expandedFilterNotifier,
    required this.onProvinceChange,
    required this.markers,
    required this.latitudeController,
    required this.longitudeController,
    required this.onApply,
    required this.onDone,
    required this.currentLatLng,
  }) : super(key: key);

  final MapScreen widget;
  final ValueNotifier<bool> expandedFilterNotifier;
  final void Function(String?) onProvinceChange;
  final List<Marker> markers;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final void Function() onApply;
  final void Function() onDone;
  final LatLng? currentLatLng;

  @override
  _PlaceInfoFieldState createState() => _PlaceInfoFieldState();
}

class _PlaceInfoFieldState extends State<PlaceInfoField> with CgThemeMixin, CgMediaQueryMixin {
  @override
  Widget build(BuildContext context) {
    if (widget.widget.settings.flowType != MapFlowType.pick) return SizedBox();
    return ValueListenableBuilder<bool>(
      valueListenable: widget.expandedFilterNotifier,
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
            widget.expandedFilterNotifier.value = expanded;
          },
          title: Text(
            "Filter",
            style: textTheme.bodyText1?.copyWith(
              color: widget.expandedFilterNotifier.value ? colorScheme.onSurface : null,
            ),
          ),
        );
      },
    );
  }

  Widget buildProvinceDropDown() {
    return CgDropDownField(
      onChanged: widget.onProvinceChange,
      items: List.generate(
        CambodiaGeography.instance.tbProvinces.length,
        (index) {
          return CambodiaGeography.instance.tbProvinces[index].khmer ?? "";
        },
      ),
    );
  }

  Widget buildLatLngField() {
    LatLng? latLng;
    if (widget.markers.isNotEmpty) latLng = widget.markers.first.position;
    return Row(
      children: [
        Expanded(
          child: CgTextField(
            labelText: "Latitude",
            value: latLng?.latitude.toString(),
            controller: widget.latitudeController,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: CgTextField(
            labelText: "Longtitude",
            value: latLng?.longitude.toString(),
            controller: widget.longitudeController,
          ),
        ),
      ],
    );
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
            onPressed: widget.currentLatLng != null ? widget.onApply : null,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: CgButton(
            labelText: "Done",
            iconData: Icons.check,
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            onPressed: widget.currentLatLng != null ? widget.onDone : null,
          ),
        ),
      ],
    );
  }
}
