import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:cambodia_geography/widgets/cg_filter_geo_fields.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({Key? key, this.filter}) : super(key: key);

  final PlaceModel? filter;

  @override
  _SearchFilterScreenState createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> with CgThemeMixin {
  PlaceModel? place;

  @override
  void initState() {
    place = widget.filter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: MorphingAppBar(
        elevation: 0.5,
        leading: CloseButton(
          color: colorScheme.primary,
        ),
        backgroundColor: colorScheme.surface,
        title: CgAppBarTitle(
          title: tr("title.filter"),
          textStyle: themeData.appBarTheme.titleTextStyle?.copyWith(color: colorScheme.onSurface),
        ),
        actions: [
          CgButton(
            onPressed: () {
              Navigator.of(context).pop(place);
            },
            labelText: tr("button.filter"),
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.primary,
          ),
        ],
      ),
      body: ListView(
        padding: ConfigConstant.layoutPadding,
        children: [
          CgFilterGeoFields(
            filter: widget.filter,
            onChanged: (PlaceModel _place) {
              this.place = _place;
            },
          )
        ],
      ),
    );
  }
}
