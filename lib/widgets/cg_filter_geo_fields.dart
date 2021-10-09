import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_commune_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/models/tb_village_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CgFilterGeoFields extends StatefulWidget {
  const CgFilterGeoFields({
    Key? key,
    this.filter,
    this.isAdmin = false,
    required this.onChanged,
  }) : super(key: key);

  final PlaceModel? filter;
  final void Function(PlaceModel) onChanged;
  final bool isAdmin;

  @override
  _CgFilterGeoFieldsState createState() => _CgFilterGeoFieldsState();
}

class _CgFilterGeoFieldsState extends State<CgFilterGeoFields> with CgThemeMixin, CgMediaQueryMixin {
  late PlaceModel _filter;

  @override
  void initState() {
    super.initState();
    setInitialFilter();
  }

  void setInitialFilter() {
    _filter = widget.filter ?? PlaceModel.empty();
    _filter.type = widget.filter?.type;
    _filter.provinceCode = widget.filter?.provinceCode;
    _filter.districtCode = widget.filter?.districtCode;
    _filter.communeCode = widget.filter?.communeCode;
    _filter.villageCode = widget.filter?.villageCode;
    if (_filter.provinceCode != null) {
      districts = geo.districtsSearch(provinceCode: _filter.provinceCode!);
      if (_filter.districtCode != null) {
        communes = geo.communesSearch(districtCode: _filter.districtCode!);
        if (_filter.communeCode != null) {
          villages = geo.villagesSearch(communeCode: _filter.communeCode!);
        }
      }
    }
  }

  CambodiaGeography geo = CambodiaGeography.instance;
  List<TbProvinceModel> provinces = [];
  List<TbDistrictModel> districts = [];
  List<TbCommuneModel> communes = [];
  List<TbVillageModel> villages = [];

  List<CgDropDownFieldItem> get placeTypes => [
        CgDropDownFieldItem(label: tr('place_type.empty'), value: null),
        CgDropDownFieldItem(label: tr('place_type.restaurant'), value: 'restaurant'),
        CgDropDownFieldItem(label: tr('place_type.place'), value: 'place'),
        CgDropDownFieldItem(label: tr('place_type.province'), value: 'province'),
        if (widget.isAdmin == true) CgDropDownFieldItem(label: tr('place_type.draft'), value: 'draft'),
        CgDropDownFieldItem(label: tr('place_type.geo'), value: 'geo')
      ];

  List<CgDropDownFieldItem> get provinceDropDownItems {
    return geo.tbProvinces.map((e) {
      return CgDropDownFieldItem(
        label: e.nameTr.toString(),
        value: e.code,
      );
    }).toList();
  }

  List<CgDropDownFieldItem> get districtsDropDownItems {
    return districts.map((e) {
      return CgDropDownFieldItem(
        label: e.nameTr.toString(),
        value: e.code,
      );
    }).toList();
  }

  List<CgDropDownFieldItem> get communeDropDownItems {
    return communes.map((e) {
      return CgDropDownFieldItem(
        label: e.nameTr.toString(),
        value: e.code,
      );
    }).toList();
  }

  List<CgDropDownFieldItem> get villageDropDownItems {
    return villages.map((e) {
      return CgDropDownFieldItem(
        label: e.nameTr.toString(),
        value: e.code,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildPlaceTypeDropDownField(),
        const SizedBox(height: ConfigConstant.margin1),
        buildProvinceDropDownField(),
        const SizedBox(height: ConfigConstant.margin1),
        if (districts.isNotEmpty) buildDistrictDropDownField(),
        if (communes.isNotEmpty) const SizedBox(height: ConfigConstant.margin1),
        if (communes.isNotEmpty) buildCommunesDropDownField(),
        if (villages.isNotEmpty) const SizedBox(height: ConfigConstant.margin1),
        if (villages.isNotEmpty) buildVillageDropDownField(),
      ],
    );
  }

  Widget buildPlaceTypeDropDownField() {
    return CgDropDownField(
      initValue: _filter.type,
      labelText: tr("label.place_type"),
      fillColor: colorScheme.background,
      items: placeTypes,
      onChanged: (value) {
        setState(
          () {
            _filter.type = value;
          },
        );
        widget.onChanged(_filter);
      },
    );
  }

  Widget buildProvinceDropDownField() {
    return CgDropDownField(
      initValue: _filter.provinceCode,
      labelText: tr("label.province"),
      fillColor: colorScheme.background,
      items: [
        CgDropDownFieldItem(label: tr("place_type.empty"), value: null),
        ...provinceDropDownItems,
      ],
      onChanged: (provinceCode) {
        _filter.districtCode = null;
        _filter.communeCode = null;
        _filter.villageCode = null;
        if (provinceCode == null) {
          setState(() {
            districts.clear();
            communes.clear();
            villages.clear();
          });
          widget.onChanged(_filter);
          return;
        }
        setState(() {
          _filter.provinceCode = provinceCode;
          districts = geo.districtsSearch(provinceCode: _filter.provinceCode.toString());
          print(districts);
        });
        widget.onChanged(_filter);
      },
    );
  }

  Widget buildDistrictDropDownField() {
    return CgDropDownField(
      initValue: _filter.districtCode,
      labelText: tr("label.district"),
      fillColor: colorScheme.background,
      key: Key(_filter.provinceCode ?? districts.join()),
      items: [
        CgDropDownFieldItem(label: tr("place_type.empty"), value: null),
        ...districtsDropDownItems,
      ],
      onChanged: (dynamic districtCode) {
        _filter.districtCode = null;
        _filter.communeCode = null;
        _filter.villageCode = null;
        if (districtCode == null) {
          setState(() {
            villages.clear();
            communes.clear();
          });
          widget.onChanged(_filter);
          return;
        }
        setState(() {
          _filter.districtCode = districtCode;
          communes = geo.communesSearch(districtCode: _filter.districtCode.toString());
          print(communes);
        });
        widget.onChanged(_filter);
      },
    );
  }

  Widget buildCommunesDropDownField() {
    return CgDropDownField(
      initValue: _filter.communeCode,
      labelText: tr("label.commune"),
      fillColor: colorScheme.background,
      key: Key(_filter.districtCode ?? communes.join()),
      items: [
        CgDropDownFieldItem(label: tr("place_type.empty"), value: null),
        ...communeDropDownItems,
      ],
      onChanged: (dynamic communeCode) {
        _filter.communeCode = null;
        _filter.villageCode = null;
        if (communeCode == null) {
          setState(() {
            villages.clear();
          });
          widget.onChanged(_filter);
          return;
        }
        setState(() {
          _filter.communeCode = communeCode;
          villages = geo.villagesSearch(communeCode: communeCode.toString());
        });
        widget.onChanged(_filter);
      },
    );
  }

  Widget buildVillageDropDownField() {
    return CgDropDownField(
      initValue: _filter.villageCode,
      labelText: tr("label.village"),
      fillColor: colorScheme.background,
      key: Key(_filter.communeCode ?? villages.join()),
      items: [
        CgDropDownFieldItem(label: tr("place_type.empty"), value: null),
        ...villageDropDownItems,
      ],
      onChanged: (dynamic villageCode) {
        if (villageCode == null) {
          _filter.villageCode = null;
          widget.onChanged(_filter);
          return;
        }
        setState(() {
          _filter.villageCode = villageCode;
        });
        widget.onChanged(_filter);
      },
    );
  }
}
