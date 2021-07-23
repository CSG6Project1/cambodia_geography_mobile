import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
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
              Navigator.of(context).pop();
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
            fillColor: colorScheme.surface,
            items: placeTypes,
            onChanged: (value) {
              setState(() {
                _placeType = value;
              });
            },
          ),
          const SizedBox(height: ConfigConstant.margin1),
          CgDropDownField(
            fillColor: colorScheme.surface,
            items: geo.tbProvinces.map((e) => e.khmer.toString()).toList(),
            onChanged: (value) {
              districts.clear();
              communes.clear();
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
              fillColor: colorScheme.surface,
              key: Key(districts.join()),
              items: districts,
              onChanged: (value) {
                villages.clear();
                communes.clear();
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
              fillColor: colorScheme.surface,
              key: Key(communes.join()),
              items: communes,
              onChanged: (value) {
                villages.clear();
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
              fillColor: colorScheme.surface,
              key: Key(villages.join()),
              items: communes,
              onChanged: (value) {
                setState(() {
                  var selectedVillage = geo.tbVillages.where((e) => e.khmer == value).toList();
                  _villageCode = selectedVillage.first.code;
                });
              },
            ),
        ],
      ),
    );
  }
}
