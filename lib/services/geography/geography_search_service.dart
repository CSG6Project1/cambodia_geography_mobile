import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/models/base_model.dart';
import 'package:cambodia_geography/models/search/autocompleter_model.dart';
import 'package:cambodia_geography/models/tb_commune_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/models/tb_village_model.dart';
import 'package:fuzzy/fuzzy.dart';

class GeographySearchService {
  List<AutocompleterModel> autocompletion(String keyword) {
    List<AutocompleterModel> items = [];

    items = [
      ..._geoToAutocompleterModelList(_provinces()),
      ..._geoToAutocompleterModelList(_districts()),
      ..._geoToAutocompleterModelList(_communes()),
      ..._geoToAutocompleterModelList(_villages()),
    ];

    bool searchInEnglish = _isSearchInEnglish(keyword);
    bool searchInKhmer = _isSearchInKhmer(keyword);

    if (searchInEnglish) {
      items = items.where((element) {
        return element.english?.contains(keyword) == true;
      }).toList();
      items = _maxList<AutocompleterModel>(items);
      items = items.map((e) {
        return e.copyWith(
          english: surroundQueryText(
            "<b>",
            "</b>",
            e.english ?? "",
            keyword,
          ),
        );
      }).toList();
    } else if (searchInKhmer) {
      items = items.where((element) {
        return element.khmer?.contains(keyword) == true;
      }).toList();
      items = _maxList<AutocompleterModel>(items);
      items = items.map((e) {
        return e.copyWith(
          english: surroundQueryText(
            "<b>",
            "</b>",
            e.khmer ?? "",
            keyword,
          ),
        );
      }).toList();
    }

    return items;
  }

  String surroundQueryText(String left, String right, String nameTr, String query) {
    String textBefore = nameTr.substring(0, nameTr.indexOf(query));
    String textAfter = nameTr.substring(nameTr.lastIndexOf(query) + query.length);
    String newTextValue = textBefore + '$left$query$right' + textAfter;
    return newTextValue;
  }

  bool _isSearchInKhmer(String keyword) {
    return keyword.codeUnitAt(0) > 6000 && keyword.codeUnitAt(0) < 6200;
  }

  bool _isSearchInEnglish(String keyword) {
    return keyword.codeUnitAt(0) >= 48 && keyword.codeUnitAt(0) < 130;
  }

  List<T> _maxList<T>(List<T> list, [int maxLength = 10]) {
    if (list.length <= maxLength) return list;
    return List.generate(maxLength, (index) => list[index]);
  }

  List<AutocompleterModel> _geoToAutocompleterModelList(Iterable<dynamic> list) {
    if (list.isEmpty) return [];
    dynamic first = list.first;
    assert(first is TbProvinceModel || first is TbDistrictModel || first is TbCommuneModel || first is TbVillageModel);

    return list.map((e) {
      String? type;
      if (e is TbProvinceModel) {
        type = "PROVINCE";
      } else if (e is TbDistrictModel && e.provinceCode != null) {
        type = e.type;
      } else if (e is TbCommuneModel) {
        type = e.type;
      } else if (e is TbVillageModel) {
        type = "VILLAGE";
      }

      return AutocompleterModel(
        id: e.code,
        khmer: e.khmer,
        english: e.english,
        type: type,
        shouldDisplayType: true,
      );
    }).toList();
  }

  String? getProvinceDisplayRoute(String? provinceCode, String languageCode) {
    Iterable<TbProvinceModel> list = CambodiaGeography.instance.tbProvinces.where((p) => p.code == provinceCode);
    if (list.isEmpty) return null;

    TbProvinceModel result = list.first;
    switch (languageCode) {
      case "km":
        return result.khmer;
      case "en":
        return result.english;
    }
  }

  String? getDistrictDisplayRoute(String districtCode, String languageCode) {
    Iterable<TbDistrictModel> list = CambodiaGeography.instance.tbDistricts.where((p) => p.code == districtCode);
    if (list.isEmpty) return null;

    TbDistrictModel result = list.first;
    String? province = getProvinceDisplayRoute(result.provinceCode, languageCode);

    switch (languageCode) {
      case "km":
        return province ?? "" + "/" + result.khmer!;
      case "en":
        return province ?? "" + "/" + result.english!;
    }
  }

  String? getCommuneDisplayRoute(String communeCode, String languageCode) {
    Iterable<TbCommuneModel> list = CambodiaGeography.instance.tbCommunes.where((p) => p.code == communeCode);
    if (list.isEmpty) return null;

    TbCommuneModel result = list.first;
    String? district = getDistrictDisplayRoute(result.districtCode!, languageCode);

    switch (languageCode) {
      case "km":
        return district ?? "" + "/" + result.khmer!;
      case "en":
        return district ?? "" + "/" + result.english!;
    }
  }

  @Deprecated('migration')
  List<GeoSearchResult> geoToGeoSearchResult(Iterable<dynamic> list, {required String languageCode}) {
    if (list.isEmpty) return [];
    dynamic first = list.first;
    assert(first is TbProvinceModel || first is TbDistrictModel || first is TbCommuneModel || first is TbVillageModel);
    return list.map((e) {
      String? optionText;
      String? type;

      if (e is TbProvinceModel) {
        optionText = "/";
        type = "PROVINCE";
      } else if (e is TbDistrictModel && e.provinceCode != null) {
        optionText = getProvinceDisplayRoute(e.provinceCode!, languageCode);
        type = e.type;
      } else if (e is TbCommuneModel) {
        optionText = getDistrictDisplayRoute(e.districtCode!, languageCode);
        type = e.type;
      } else if (e is TbVillageModel) {
        optionText = getCommuneDisplayRoute(e.communeCode!, languageCode);
        type = "VILLAGE";
      }

      return GeoSearchResult(
        khmer: e.khmer,
        english: e.english,
        code: e.code,
        optionText: optionText,
        type: type,
      );
    }).toList();
  }

  List<T> listOfListToList<T>(List<List<T>> list) {
    List<T> result = [];
    list.forEach((element) {
      result.addAll(element);
    });
    return result;
  }

  FuzzyOptions<dynamic> fuzzyOptions() => FuzzyOptions(isCaseSensitive: false);

  Iterable<TbProvinceModel> _provinces() => CambodiaGeography.instance.tbProvinces;
  Iterable<TbDistrictModel> _districts() => CambodiaGeography.instance.tbDistricts;
  Iterable<TbCommuneModel> _communes() => CambodiaGeography.instance.tbCommunes;
  Iterable<TbVillageModel> _villages() => CambodiaGeography.instance.tbVillages;
}

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
