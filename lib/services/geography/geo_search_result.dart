import 'package:cambodia_geography/models/base_model.dart';

class GeoSearchResult extends BaseModel {
  final String code;
  final String khmer;
  final String english;
  final String? optionText;
  final String? type;

  GeoSearchResult({
    required this.code,
    required this.khmer,
    required this.english,
    required this.optionText,
    required this.type,
  });

  @override
  String? get en => this.english;

  @override
  String? get km => this.khmer;
}
