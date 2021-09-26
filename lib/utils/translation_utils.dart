import 'package:cambodia_geography/app.dart';

String numberTr(dynamic number) {
  switch (App.locale?.languageCode) {
    case "km":
      return _toKhmer(number);
    case "en":
      return _toEnglish(number);
    default:
      return _toKhmer(number);
  }
}

String _toKhmer(dynamic number) {
  String numConvert = '$number';
  for (int i = 0; i < _khmer.length; i++) {
    numConvert = numConvert.replaceAll(_english[i], _khmer[i]);
  }
  return numConvert;
}

String _toEnglish(dynamic number) {
  String numConvert = '$number';
  for (int i = 0; i < _english.length; i++) {
    numConvert = numConvert.replaceAll(_khmer[i], _english[i]);
  }
  return numConvert;
}

const _english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
const _khmer = ['០', '១', '២', '៣', '៤', '៥', '៦', '៧', '៨', '៩'];
