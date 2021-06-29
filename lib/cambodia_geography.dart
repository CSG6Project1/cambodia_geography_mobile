import 'dart:convert';
import './models/tb_commune_model.dart';
import './models/tb_district_model.dart';
import './models/tb_province_model.dart';
import './models/tb_village_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class CambodiaGeography {
  List<TbCommuneModel> tbCommunes = [];
  List<TbDistrictModel> tbDistricts = [];
  List<TbProvinceModel> tbProvinces = [];
  List<TbVillageModel> tbVillages = [];

  List<TbDistrictModel> districtsSearch({required String provinceCode}) {
    return this.tbDistricts.where((e) => e.provinceCode == provinceCode).toList();
  }

  List<TbCommuneModel> communesSearch({required String districtCode}) {
    return this.tbCommunes.where((e) => e.districtCode == districtCode).toList();
  }

  List<TbVillageModel> villagesSearch({required String communeCode}) {
    return this.tbVillages.where((e) => e.communeCode == communeCode).toList();
  }

  Future<void> initilize() async {
    tbCommunes = await rootBundle.loadString('assets/tb_commune.json').then((value) {
      List<dynamic> json = jsonDecode(value);
      return json.map((e) {
        final data = TbCommuneModel.fromJson(e);
        return data;
      }).toList();
    });

    tbDistricts = await rootBundle.loadString('assets/tb_district.json').then((value) {
      List<dynamic> json = jsonDecode(value);
      return json.map((e) {
        final data = TbDistrictModel.fromJson(e);
        return data;
      }).toList();
    });

    tbProvinces = await rootBundle.loadString('assets/tb_province.json').then((value) {
      List<dynamic> json = jsonDecode(value);
      return json.map((e) {
        final data = TbProvinceModel.fromJson(e);
        return data;
      }).toList();
    });

    tbVillages = await rootBundle.loadString('assets/tb_village.json').then((value) {
      List<dynamic> json = jsonDecode(value);
      return json.map((e) {
        final data = TbVillageModel.fromJson(e);
        return data;
      }).toList();
    });
  }
}
