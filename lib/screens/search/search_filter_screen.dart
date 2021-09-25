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
  const SearchFilterScreen({Key? key}) : super(key: key);

  @override
  _SearchFilterScreenState createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> with CgThemeMixin {
  String? _placeType;
  String? _provinceCode;
  String? _districtCode;
  String? _communeCode;
  String? _villageCode;

  CambodiaGeography geo = CambodiaGeography.instance;
  List<TbProvinceModel> provinces = [];
  List<TbDistrictModel> districts = [];
  List<TbCommuneModel> communes = [];
  List<TbVillageModel> villages = [];

  List<CgDropDownFieldItem<String?>> placeTypes = [
    CgDropDownFieldItem(label: tr('place_type.empty'), value: null),
    CgDropDownFieldItem(label: tr('place_type.restuarant'), value: 'restuarant'),
    CgDropDownFieldItem(label: tr('place_type.place'), value: 'place'),
  ];

  List<CgDropDownFieldItem<String?>> get provinceDropDownItems {
    return geo.tbProvinces.map((e) {
      return CgDropDownFieldItem(
        label: e.khmer.toString(),
        value: e.code,
      );
    }).toList();
  }

  List<CgDropDownFieldItem<String?>> get districtsDropDownItems {
    return districts.map((e) {
      return CgDropDownFieldItem(
        label: e.khmer.toString(),
        value: e.code,
      );
    }).toList();
  }

  List<CgDropDownFieldItem<String?>> get communeDropDownItems {
    return communes.map((e) {
      return CgDropDownFieldItem(
        label: e.khmer.toString(),
        value: e.code,
      );
    }).toList();
  }

  List<CgDropDownFieldItem<String?>> get villageDropDownItems {
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

  Widget buildVillageDropDownField() {
    return CgDropDownField<String?>(
      labelText: "ភូមិ",
      fillColor: colorScheme.background,
      key: Key(villages.join()),
      items: [
        CgDropDownFieldItem(label: 'ទទេ', value: null),
        ...villageDropDownItems,
      ],
      onChanged: (String? villageCode) {
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

  Widget buildCommunesDropDownField() {
    return CgDropDownField<String?>(
      labelText: "ឃុំ",
      fillColor: colorScheme.background,
      key: Key(communes.join()),
      items: [
        CgDropDownFieldItem(label: 'ទទេ', value: null),
        ...communeDropDownItems,
      ],
      onChanged: (String? communeCode) {
        if (communeCode == null) {
          setState(() {
            villages.clear();
            _communeCode = null;
          });
          return;
        }
        setState(() {
          villages = geo.villagesSearch(communeCode: communeCode.toString());
        });
      },
    );
  }

  Widget buildDistrictDropDownField() {
    return CgDropDownField<String?>(
      labelText: "ស្រុក",
      fillColor: colorScheme.background,
      key: Key(districts.join()),
      items: [
        CgDropDownFieldItem(label: 'ទទេ', value: null),
        ...districtsDropDownItems,
      ],
      onChanged: (String? districtCode) {
        if (districtCode == null) {
          setState(() {
            villages.clear();
            communes.clear();
            _districtCode = null;
          });
          return;
        }
        setState(() {
          communes = geo.communesSearch(districtCode: _districtCode.toString());
          print(communes);
        });
      },
    );
  }

  Widget buildProvinceDropDownField() {
    return CgDropDownField<String?>(
      labelText: "ខេត្ត",
      fillColor: colorScheme.background,
      items: [
        CgDropDownFieldItem(label: 'ទទេ', value: null),
        ...provinceDropDownItems,
      ],
      onChanged: (provinceCode) {
        if (provinceCode == null) {
          setState(() {
            districts.clear();
            communes.clear();
            villages.clear();
            _provinceCode = null;
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

  Widget buildPlaceTypeDropDownField() {
    return CgDropDownField<String?>(
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
}
