import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/models/base_model.dart';
import 'package:cambodia_geography/models/search/autocompleter_model.dart';
import 'package:cambodia_geography/models/tb_commune_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/models/tb_village_model.dart';
import 'package:fuzzy/data/result.dart';
import 'package:fuzzy/fuzzy.dart';

class GeographySearchService {
  List<AutocompleterModel> autocompletion(String keyword) {
    List<AutocompleterModel> items = [];
    bool searchInEnglish = _isSearchInEnglish(keyword);
    bool searchInKhmer = _isSearchInKhmer(keyword);

    items = [
      ..._geoToAutocompleterModelList(_provinces()),
      ..._geoToAutocompleterModelList(_districts()),
      ..._geoToAutocompleterModelList(_communes()),
      ..._geoToAutocompleterModelList(_villages()),
    ];

    Fuzzy? fuzzy;

    if (searchInEnglish) {
      fuzzy = Fuzzy(items.map((e) => e.english).toList(), options: _fuzzyOptions());
      List<Result<dynamic>>? result = fuzzy.search(keyword);
      items = result.map((e) {
        return items.where((model) => model.english == e.item).first;
      }).toList();
    } else if (searchInKhmer) {
      fuzzy = Fuzzy(items.map((e) => e.khmer).toList(), options: _fuzzyOptions());
      List<Result<dynamic>>? result = fuzzy.search(keyword)
        ..sort((a, b) {
          return a.score.compareTo(b.score);
        });
      items = result.map((e) {
        return items.where((model) => model.khmer == e.item).first;
      }).toList();
    }

    return _maxList<AutocompleterModel>(items);
  }

  List<GeoSearchResult> search(String keyword, {required String languageCode}) {
    List<GeoSearchResult> items = [];
    bool searchInEnglish = _isSearchInEnglish(keyword);
    bool searchInKhmer = _isSearchInKhmer(keyword);

    items = [
      ...geoToGeoSearchResult(_districts(), languageCode: languageCode),
      ...geoToGeoSearchResult(_communes(), languageCode: languageCode),
      ...geoToGeoSearchResult(_villages(), languageCode: languageCode),
      ...geoToGeoSearchResult(_provinces(), languageCode: languageCode),
    ];

    Fuzzy? fuzzy;

    if (searchInEnglish) {
      fuzzy = Fuzzy(items.map((e) => e.english).toList(), options: _fuzzyOptions());
      List<Result<dynamic>>? result = fuzzy.search(keyword);
      List<List<GeoSearchResult>> searchResult = result.map((e) {
        return items.where((model) => model.english == e.item).toList();
      }).toList();
      items = _listOfListToList<GeoSearchResult>(searchResult);
    } else if (searchInKhmer) {
      fuzzy = Fuzzy(items.map((e) => e.khmer).toList(), options: _fuzzyOptions());
      List<Result<dynamic>>? result = fuzzy.search(keyword)
        ..sort((a, b) {
          return a.score.compareTo(b.score);
        });
      List<List<GeoSearchResult>> searchResult = result.map((e) {
        return items.where((model) => model.khmer == e.item).toList();
      }).toList();
      items = _listOfListToList<GeoSearchResult>(searchResult);
    }

    return _maxList(items, 10);
  }

  bool _isSearchInKhmer(String keyword) {
    return keyword.codeUnitAt(0) > 6000 && keyword.codeUnitAt(0) < 6200;
  }

  bool _isSearchInEnglish(String keyword) {
    return keyword.codeUnitAt(0) >= 48 && keyword.codeUnitAt(0) < 130;
  }

  List<T> _maxList<T>(List<T> list, [int maxLength = 5]) {
    if (list.length <= maxLength) return list;
    return List.generate(maxLength, (index) => list[index]);
  }

  List<AutocompleterModel> _geoToAutocompleterModelList(Iterable<dynamic> list) {
    if (list.isEmpty) return [];
    dynamic first = list.first;
    assert(first is TbProvinceModel || first is TbDistrictModel || first is TbCommuneModel || first is TbVillageModel);
    return list.map((e) {
      return AutocompleterModel(
        id: e.code,
        khmer: e.khmer,
        english: e.english,
        type: 'geo',
      );
    }).toList();
  }

  String? _getProvinceDisplayRoute(String? provinceCode, String languageCode) {
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

  String? _getDistrictDisplayRoute(String districtCode, String languageCode) {
    Iterable<TbDistrictModel> list = CambodiaGeography.instance.tbDistricts.where((p) => p.code == districtCode);
    if (list.isEmpty) return null;

    TbDistrictModel result = list.first;
    String? province = _getProvinceDisplayRoute(result.provinceCode, languageCode);

    switch (languageCode) {
      case "km":
        return province ?? "" + "/" + result.khmer!;
      case "en":
        return province ?? "" + "/" + result.english!;
    }
  }

  String? _getCommuneDisplayRoute(String communeCode, String languageCode) {
    Iterable<TbCommuneModel> list = CambodiaGeography.instance.tbCommunes.where((p) => p.code == communeCode);
    if (list.isEmpty) return null;

    TbCommuneModel result = list.first;
    String? district = _getDistrictDisplayRoute(result.districtCode!, languageCode);

    switch (languageCode) {
      case "km":
        return district ?? "" + "/" + result.khmer!;
      case "en":
        return district ?? "" + "/" + result.english!;
    }
  }

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
        optionText = _getProvinceDisplayRoute(e.provinceCode!, languageCode);
        type = e.type;
      } else if (e is TbCommuneModel) {
        optionText = _getDistrictDisplayRoute(e.districtCode!, languageCode);
        type = e.type;
      } else if (e is TbVillageModel) {
        optionText = _getCommuneDisplayRoute(e.communeCode!, languageCode);
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

  List<T> _listOfListToList<T>(List<List<T>> list) {
    List<T> result = [];
    list.forEach((element) {
      result.addAll(element);
    });
    return result;
  }

  FuzzyOptions<dynamic> _fuzzyOptions() => FuzzyOptions(isCaseSensitive: false);

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
