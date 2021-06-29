import 'dart:convert';
import 'dart:io';
import './models/tb_commune_model.dart';
import './models/tb_district_model.dart';
import './models/tb_province_model.dart';
import './models/tb_village_model.dart';

void main() async {
  List<TbCommuneModel> tbCommunes = await File('tb_commune.json').readAsString().then((value) {
    List<dynamic> json = jsonDecode(value);
    return json.map((e) {
      final data = TbCommuneModel.fromJson(e);
      return data;
    }).toList();
  });

  List<TbDistrictModel> tbDistricts = await File('tb_district.json').readAsString().then((value) {
    List<dynamic> json = jsonDecode(value);
    return json.map((e) {
      final data = TbDistrictModel.fromJson(e);
      return data;
    }).toList();
  });

  List<TbProvinceModel> tbProvinces = await File('tb_province.json').readAsString().then((value) {
    List<dynamic> json = jsonDecode(value);
    return json.map((e) {
      final data = TbProvinceModel.fromJson(e);
      return data;
    }).toList();
  });

  List<TbVillageModel> tbVillages = await File('tb_village.json').readAsString().then((value) {
    List<dynamic> json = jsonDecode(value);
    return json.map((e) {
      final data = TbVillageModel.fromJson(e);
      return data;
    }).toList();
  });

  tbCommunes.forEach((e) {
    print(e.id);
  });

  tbDistricts.forEach((e) {
    print(e.id);
  });

  tbProvinces.forEach((e) {
    print(e.id);
  });

  tbVillages.forEach((e) {
    print(e.id);
  });
}
