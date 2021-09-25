import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/tb_commune_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/models/tb_village_model.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
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
  String? _placeType;
  String? _provinceCode;
  String? _districtCode;
  String? _communeCode;
  String? _villageCode;

  @override
  void initState() {
    super.initState();
    setInitialFilter();
  }

  void setInitialFilter() {
    _placeType = widget.filter?.type;
    _provinceCode = widget.filter?.provinceCode;
    _districtCode = widget.filter?.districtCode;
    _communeCode = widget.filter?.communeCode;
    _villageCode = widget.filter?.villageCode;
    if (_provinceCode != null) {
      districts = geo.districtsSearch(provinceCode: _provinceCode!);
      if (_districtCode != null) {
        communes = geo.communesSearch(districtCode: _districtCode!);
        if (_communeCode != null) {
          villages = geo.villagesSearch(communeCode: _communeCode!);
        }
      }
    }
  }

  CambodiaGeography geo = CambodiaGeography.instance;
  List<TbProvinceModel> provinces = [];
  List<TbDistrictModel> districts = [];
  List<TbCommuneModel> communes = [];
  List<TbVillageModel> villages = [];

  List<CgDropDownFieldItem> placeTypes = [
    CgDropDownFieldItem(label: tr('place_type.empty'), value: null),
    CgDropDownFieldItem(label: tr('place_type.restuarant'), value: 'restuarant'),
    CgDropDownFieldItem(label: tr('place_type.place'), value: 'place'),
  ];

  List<CgDropDownFieldItem> get provinceDropDownItems {
    return geo.tbProvinces.map((e) {
      return CgDropDownFieldItem(
        label: e.khmer.toString(),
        value: e.code,
      );
    }).toList();
  }

  List<CgDropDownFieldItem> get districtsDropDownItems {
    return districts.map((e) {
      return CgDropDownFieldItem(
        label: e.khmer.toString(),
        value: e.code,
      );
    }).toList();
  }

  List<CgDropDownFieldItem> get communeDropDownItems {
    return communes.map((e) {
      return CgDropDownFieldItem(
        label: e.khmer.toString(),
        value: e.code,
      );
    }).toList();
  }

  List<CgDropDownFieldItem> get villageDropDownItems {
    return villages.map((e) {
      return CgDropDownFieldItem(
        label: e.khmer.toString(),
        value: e.code,
      );
    }).toList();
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
          title: "ការកំណត់",
          textStyle: themeData.appBarTheme.titleTextStyle?.copyWith(color: colorScheme.onSurface),
        ),
        actions: [
          CgButton(
            onPressed: () {
              Navigator.of(context).pop(PlaceModel(
                type: _placeType,
                provinceCode: _provinceCode,
                districtCode: _districtCode,
                communeCode: _communeCode,
                villageCode: _villageCode,
              ));
            },
            labelText: "កំណត់",
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.primary,
          ),
        ],
      ),
      body: ListView(
        padding: ConfigConstant.layoutPadding,
        children: [
          buildPlaceTypeDropDownField(),
          const SizedBox(height: ConfigConstant.margin1),
          buildProvinceDropDownField(),
          const SizedBox(height: ConfigConstant.margin1),
          if (districts.isNotEmpty) buildDistrictDropDownField(),
          const SizedBox(height: ConfigConstant.margin1),
          if (communes.isNotEmpty) buildCommunesDropDownField(),
          const SizedBox(height: ConfigConstant.margin1),
          if (villages.isNotEmpty) buildVillageDropDownField(),
        ],
      ),
    );
  }

  Widget buildPlaceTypeDropDownField() {
    return CgDropDownField(
      initValue: _placeType,
      labelText: "ប្រភេទទីតាំង",
      fillColor: colorScheme.background,
      items: placeTypes,
      onChanged: (value) {
        setState(() {
          if (value == placeTypes[0].value) {
            _placeType = null;
          } else if (value == placeTypes[1].value) {
            _placeType = "place";
          } else {
            _placeType = "restaurant";
          }
          print(_placeType);
        });
      },
    );
  }

  Widget buildProvinceDropDownField() {
    return CgDropDownField(
      initValue: _provinceCode,
      labelText: "ខេត្ត",
      fillColor: colorScheme.background,
      items: [
        CgDropDownFieldItem(label: 'ទទេ', value: null),
        ...provinceDropDownItems,
      ],
      onChanged: (provinceCode) {
        _districtCode = null;
        _communeCode = null;
        _villageCode = null;
        if (provinceCode == null) {
          setState(() {
            districts.clear();
            communes.clear();
            villages.clear();
          });
          return;
        }
        setState(() {
          _provinceCode = provinceCode;
          districts = geo.districtsSearch(provinceCode: _provinceCode.toString());
          print(districts);
        });
      },
    );
  }

  Widget buildDistrictDropDownField() {
    return CgDropDownField(
      initValue: _districtCode,
      labelText: "ស្រុក",
      fillColor: colorScheme.background,
      key: Key(_provinceCode ?? districts.join()),
      items: [
        CgDropDownFieldItem(label: 'ទទេ', value: null),
        ...districtsDropDownItems,
      ],
      onChanged: (dynamic districtCode) {
        _districtCode = null;
        _communeCode = null;
        _villageCode = null;
        if (districtCode == null) {
          setState(() {
            villages.clear();
            communes.clear();
          });
          return;
        }
        setState(() {
          _districtCode = districtCode;
          communes = geo.communesSearch(districtCode: _districtCode.toString());
          print(communes);
        });
      },
    );
  }

  Widget buildCommunesDropDownField() {
    return CgDropDownField(
      initValue: _communeCode,
      labelText: "ឃុំ",
      fillColor: colorScheme.background,
      key: Key(_districtCode ?? communes.join()),
      items: [
        CgDropDownFieldItem(label: 'ទទេ', value: null),
        ...communeDropDownItems,
      ],
      onChanged: (dynamic communeCode) {
        _communeCode = null;
        _villageCode = null;
        if (communeCode == null) {
          setState(() {
            villages.clear();
          });
          return;
        }
        setState(() {
          _communeCode = communeCode;
          villages = geo.villagesSearch(communeCode: communeCode.toString());
        });
      },
    );
  }

  Widget buildVillageDropDownField() {
    return CgDropDownField(
      initValue: _villageCode,
      labelText: "ភូមិ",
      fillColor: colorScheme.background,
      key: Key(_communeCode ?? villages.join()),
      items: [
        CgDropDownFieldItem(label: 'ទទេ', value: null),
        ...villageDropDownItems,
      ],
      onChanged: (dynamic villageCode) {
        if (villageCode == null) {
          _villageCode = null;
          return;
        }
        setState(() {
          _villageCode = villageCode;
        });
      },
    );
  }
}
