import 'dart:convert';
import './models/tb_commune_model.dart';
import './models/tb_district_model.dart';
import './models/tb_province_model.dart';
import './models/tb_village_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class CambodiaGeography {
  CambodiaGeography._privateConstructor();
  static final CambodiaGeography instance = CambodiaGeography._privateConstructor();

  List<TbCommuneModel> get tbCommunes => _tbCommunes;
  List<TbDistrictModel> get tbDistricts => _tbDistricts;
  List<TbProvinceModel> get tbProvinces => _tbProvinces;
  List<TbVillageModel> get tbVillages => _tbVillages;

  static List<TbCommuneModel> _tbCommunes = [];
  static List<TbDistrictModel> _tbDistricts = [];
  static List<TbProvinceModel> _tbProvinces = [];
  static List<TbVillageModel> _tbVillages = [];

  List<TbDistrictModel> districtsSearch({required String provinceCode}) {
    return _tbDistricts.where((e) => e.provinceCode == provinceCode).toList();
  }

  List<TbCommuneModel> communesSearch({required String districtCode}) {
    return _tbCommunes.where((e) => e.districtCode == districtCode).toList();
  }

  List<TbVillageModel> villagesSearch({required String communeCode}) {
    return _tbVillages.where((e) => e.communeCode == communeCode).toList();
  }

  Future<void> initilize() async {
    _tbCommunes = await rootBundle.loadString('assets/tb_commune.json').then((value) {
      List<dynamic> json = jsonDecode(value);
      return json.map((e) {
        final data = TbCommuneModel.fromJson(e);
        return data;
      }).toList();
    });

    _tbDistricts = await rootBundle.loadString('assets/tb_district.json').then((value) {
      List<dynamic> json = jsonDecode(value);
      return json.map((e) {
        final data = TbDistrictModel.fromJson(e);
        return data;
      }).toList();
    });

    _tbProvinces = await rootBundle.loadString('assets/tb_province.json').then((value) {
      List<dynamic> json = jsonDecode(value);
      return json.map((e) {
        final data = TbProvinceModel.fromJson(e);
        return data;
      }).toList();
    });

    _tbVillages = await rootBundle.loadString('assets/tb_village.json').then((value) {
      List<dynamic> json = jsonDecode(value);
      return json.map((e) {
        final data = TbVillageModel.fromJson(e);
        return data;
      }).toList();
    });
  }
}
