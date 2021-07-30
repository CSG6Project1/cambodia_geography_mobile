import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
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

  final geo = CambodiaGeography.instance;
  List<String> provinces = [];
  List<String> districts = [];
  List<String> communes = [];
  List<String> villages = [];
  List<String> placeTypes = ["តំបន់ទេសចរណ៍", "ភោជនីយដ្ឋាន"];

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
                provinceCode: _provinceCode,
                districtCode: _districtCode,
                communeCode: _communeCode,
                villageCode: _villageCode)
              );
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
          CgDropDownField(
            fillColor: colorScheme.background,
            items: placeTypes,
            onChanged: (value) {
              setState(() {
                _placeType = value;
                print(_placeType);
              });
            },
          ),
          const SizedBox(height: ConfigConstant.margin1),
          CgDropDownField(
            labelText: "ខេត្ត",
            fillColor: colorScheme.background,
            items: ["ទទេ", ...geo.tbProvinces.map((e) => e.khmer.toString()).toList()],
            onChanged: (value) {
              if (value == "ទទេ") {
                setState(() {
                  districts.clear();
                  communes.clear();
                  _provinceCode = null;
                });
                return;
              }
              setState(() {
                var selectedProvince = geo.tbProvinces.where((e) => e.khmer == value).toList();
                _provinceCode = selectedProvince.first.code;
                districts =
                    geo.districtsSearch(provinceCode: _provinceCode.toString()).map((e) => e.khmer.toString()).toList();
                print(districts);
              });
            },
          ),
          const SizedBox(height: ConfigConstant.margin1),
          if (districts.isNotEmpty)
            CgDropDownField(
              labelText: "ស្រុក",
              fillColor: colorScheme.background,
              key: Key(districts.join()),
              items: ["ទទេ", ...districts],
              onChanged: (value) {
                if (value == "ទទេ") {
                  setState(() {
                    villages.clear();
                    communes.clear();
                    _districtCode = null;
                  });
                  return;
                }
                setState(() {
                  var selectedDistrict = geo.tbDistricts.where((e) => e.khmer == value).toList();
                  _districtCode = selectedDistrict.first.code;
                  communes = geo
                      .communesSearch(districtCode: _districtCode.toString())
                      .map((e) => e.khmer.toString())
                      .toList();
                  print(communes);
                });
              },
            ),
          const SizedBox(height: ConfigConstant.margin1),
          if (communes.isNotEmpty)
            CgDropDownField(
              labelText: "ឃុំ",
              fillColor: colorScheme.background,
              key: Key(communes.join()),
              items: ["ទទេ", ...communes],
              onChanged: (value) {
                if (value == "ទទេ") {
                  setState(() {
                    villages.clear();
                    _communeCode = null;
                  });
                  return;
                }
                setState(() {
                  var selectedCommune = geo.tbCommunes.where((e) => e.khmer == value).toList();
                  _communeCode = selectedCommune.first.code;
                  villages =
                      geo.villagesSearch(communeCode: _communeCode.toString()).map((e) => e.khmer.toString()).toList();
                });
              },
            ),
          const SizedBox(height: ConfigConstant.margin1),
          if (villages.isNotEmpty)
            CgDropDownField(
              labelText: "ភូមិ",
              fillColor: colorScheme.background,
              key: Key(villages.join()),
              items: ["ទទេ", ...communes],
              onChanged: (value) {
                if (value == "ទទេ") {
                  _villageCode = null;
                  return;
                }
                setState(() {
                  var selectedVillage = geo.tbVillages.where((e) => e.khmer == value).toList();
                  _villageCode = selectedVillage.first.code;
                  print(_villageCode);
                });
              },
            ),
        ],
      ),
    );
  }
}
