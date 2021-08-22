import 'package:cambodia_geography/models/search/autocompleter_list_model.dart';
import 'package:cambodia_geography/models/search/autocompleter_model.dart';
import 'package:cambodia_geography/services/apis/base_app_api.dart';


class SearchAutocompleteApi extends BaseAppApi<AutocompleterModel> {
  @override
  String get nameInUrl => "autocompleter/result";

  @override
  bool get useJapx => false;

  @override
  AutocompleterModel objectTransformer(Map<String, dynamic> json) {
    return AutocompleterModel.fromJson(json);
  }

  @override
  AutocompleterListModel itemsTransformer(Map<String, dynamic> json) {
    return AutocompleterListModel(
      items: buildItems(json),
      meta: buildMeta(json),
      links: buildLinks(json),
    );
  }

  Future<dynamic> fetchAutocompleters({
    String? keyword,
  }) {
    return super.fetchAll(queryParameters: {
      "keyword": keyword,
    });
  }
}
