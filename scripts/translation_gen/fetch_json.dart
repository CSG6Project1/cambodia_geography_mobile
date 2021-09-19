import 'dart:io';
import 'package:cambodia_geography/constants/api_constant.dart';
import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

void main() async {
  Dio dio = Dio();
  Response<dynamic> response;
  String endpoint = ApiConstant.localizeEndPoint;
  response = await dio.get(endpoint);

  var translations = CsvToListConverter().convert(response.toString());

  final kmFileName = 'assets/translations/km.json';
  final enFileName = 'assets/translations/en.json';

  Map<String, dynamic> en = {};
  Map<String, dynamic> km = {};

  translations.forEach((row) {
    en[row[0]] = row[1];
    km[row[0]] = row[2];
  });

  _writeToFile(kmFileName, km);
  _writeToFile(enFileName, en);
}

_writeToFile(String filePath, Map data) {
  File(filePath).writeAsString(_prettifyJson(data)).then((File file) {
    print('$filePath created');
  });
}

_prettifyJson(Map<dynamic, dynamic> json) {
  JsonEncoder encoder = new JsonEncoder.withIndent("  ");
  String prettyJson = encoder.convert(json);
  return prettyJson;
}
