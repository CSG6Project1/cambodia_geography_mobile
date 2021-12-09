import 'dart:convert';
import 'dart:io';
import 'package:cambodia_geography/gen/assets.gen.dart';
import 'package:flutter/foundation.dart';

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

  TbProvinceModel? provinceByDistrictCode(String districtCode) {
    Iterable<TbDistrictModel> district = tbDistricts.where((e) => e.code == districtCode);
    if (district.isNotEmpty) {
      Iterable<TbProvinceModel> provinces = tbProvinces.where((e) => e.code == district.first.provinceCode);
      return provinces.isNotEmpty ? provinces.first : null;
    }
  }

  TbDistrictModel? districtByCommuneCode(String communeCode) {
    Iterable<TbCommuneModel> commune = tbCommunes.where((e) => e.code == communeCode);
    if (commune.isNotEmpty) {
      Iterable<TbDistrictModel> districts = tbDistricts.where((e) => e.code == commune.first.districtCode);
      return districts.isNotEmpty ? districts.first : null;
    }
  }

  TbCommuneModel? communeByVillageCode(String villageCode) {
    Iterable<TbVillageModel> villages = tbVillages.where((e) => e.code == villageCode);
    if (villages.isNotEmpty) {
      Iterable<TbCommuneModel> communes = tbCommunes.where((e) => e.code == villages.first.communeCode);
      return communes.isNotEmpty ? communes.first : null;
    }
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

    _tbCommunes = await compute<String, List<TbCommuneModel>>(_getCommunes, tbCommune);
    _tbDistricts = await compute<String, List<TbDistrictModel>>(_getDistricts, tbDistrict);
    _tbProvinces = await compute<String, List<TbProvinceModel>>(_getProvinces, tbProvince);
    _tbVillages = await compute<String, List<TbVillageModel>>(_getVillages, tbVillage);
  }
}

List<TbCommuneModel> _getCommunes(String tbCommune) {
  List<dynamic> tbCommuneJson = jsonDecode(tbCommune);
  return tbCommuneJson.map((e) {
    return TbCommuneModel.fromJson(e);
  }).toList();
}

List<TbDistrictModel> _getDistricts(String tbDistrict) {
  List<dynamic> tbDistrictJson = jsonDecode(tbDistrict);
  return tbDistrictJson.map((e) {
    return TbDistrictModel.fromJson(e);
  }).toList();
}

List<TbProvinceModel> _getProvinces(String tbProvince) {
  List<dynamic> tbProvinceJson = jsonDecode(tbProvince);
  return tbProvinceJson.map((e) {
    return TbProvinceModel.fromJson(e);
  }).toList();
}

List<TbVillageModel> _getVillages(String tbVillage) {
  List<dynamic> tbVillageJson = jsonDecode(tbVillage);
  return tbVillageJson.map((e) {
    return TbVillageModel.fromJson(e);
  }).toList();
}
