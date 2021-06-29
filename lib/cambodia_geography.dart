import 'dart:convert';
import 'dart:io';
import './models/tb_commune_model.dart';
import './models/tb_district_model.dart';
import './models/tb_province_model.dart';
import './models/tb_village_model.dart';

class CambodiaGeography {
  List<TbCommuneModel> tbCommunes = [];
  List<TbDistrictModel> tbDistricts = [];
  List<TbProvinceModel> tbProvinces = [];
  List<TbVillageModel> tbVillages = [];

  CambodiaGeography() {
    _initilize();
  }

  Future<void> _initilize() async {
    tbCommunes = await File('tb_commune.json').readAsString().then((value) {
      List<dynamic> json = jsonDecode(value);
      return json.map((e) {
        final data = TbCommuneModel.fromJson(e);
        return data;
      }).toList();
    });

    tbDistricts = await File('tb_district.json').readAsString().then((value) {
      List<dynamic> json = jsonDecode(value);
      return json.map((e) {
        final data = TbDistrictModel.fromJson(e);
        return data;
      }).toList();
    });

    tbProvinces = await File('tb_province.json').readAsString().then((value) {
      List<dynamic> json = jsonDecode(value);
      return json.map((e) {
        final data = TbProvinceModel.fromJson(e);
        return data;
      }).toList();
    });

    tbVillages = await File('tb_village.json').readAsString().then((value) {
      List<dynamic> json = jsonDecode(value);
      return json.map((e) {
        final data = TbVillageModel.fromJson(e);
        return data;
      }).toList();
    });
  }
}
