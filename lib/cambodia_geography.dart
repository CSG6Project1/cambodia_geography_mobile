import 'dart:convert';
import 'dart:io';
import 'package:cambodia_geography/gen/assets.gen.dart';

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
    String tbCommune;
    String tbDistrict;
    String tbProvince;
    String tbVillage;

    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      tbCommune = await File(Assets.tbCommune).readAsString();
      tbDistrict = await File(Assets.tbDistrict).readAsString();
      tbProvince = await File(Assets.tbProvince).readAsString();
      tbVillage = await File(Assets.tbVillage).readAsString();
    } else {
      tbCommune = await rootBundle.loadString(Assets.tbCommune);
      tbDistrict = await rootBundle.loadString(Assets.tbDistrict);
      tbProvince = await rootBundle.loadString(Assets.tbProvince);
      tbVillage = await rootBundle.loadString(Assets.tbVillage);
    }

    List<dynamic> tbCommuneJson = jsonDecode(tbCommune);
    _tbCommunes = tbCommuneJson.map((e) {
      final data = TbCommuneModel.fromJson(e);
      return data;
    }).toList();

    List<dynamic> tbDistrictJson = jsonDecode(tbDistrict);
    _tbDistricts = tbDistrictJson.map((e) {
      final data = TbDistrictModel.fromJson(e);
      return data;
    }).toList();

    List<dynamic> tbProvinceJson = jsonDecode(tbProvince);
    _tbProvinces = tbProvinceJson.map((e) {
      final data = TbProvinceModel.fromJson(e);
      return data;
    }).toList();

    List<dynamic> tbVillageJson = jsonDecode(tbVillage);
    _tbVillages = tbVillageJson.map((e) {
      final data = TbVillageModel.fromJson(e);
      return data;
    }).toList();
  }
}
