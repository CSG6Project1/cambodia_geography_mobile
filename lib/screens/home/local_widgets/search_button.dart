import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/search/autocompleter_list_model.dart';
import 'package:cambodia_geography/models/search/autocompleter_model.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/screens/search/cg_search_delegate.dart';
import 'package:cambodia_geography/screens/search/search_history_storage.dart';
import 'package:cambodia_geography/services/apis/search/search_autocomplete_api.dart';
import 'package:cambodia_geography/services/geography/geography_search_service.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;

  void onPressed(BuildContext context) async {
    animationController.forward();
    await showSearch(
      context: context,
      delegate: CgSearchDelegate(
        onQueryChanged: (String query, PlaceType? type) {
          if (query.isEmpty) {
            SearchHistoryStorage storage = SearchHistoryStorage();
            Future<List<dynamic>?> value = storage.readList();
            return Stream.fromFuture(value);
          } else {
            if (type == PlaceType.geo) {
              GeographySearchService service = GeographySearchService();
              List<AutocompleterModel> localResult = service.autocompletion(query);
              List<String?> listLocalResult = localResult.map((e) => e.nameTr).toList();
              return Stream.fromFuture(Future.value(listLocalResult));
            } else {
              SearchAutocompleteApi autoCompleterApi = SearchAutocompleteApi();
              Future<List<String?>> listApiResult = autoCompleterApi.fetchAutocompleters(keyword: query).then(
                (result) {
                  List<String?> autocompleteResult = [];
                  if (autoCompleterApi.success() && result is AutocompleterListModel) {
                    bool nameTr = result.items?[0].nameTr?.contains("<b>") == true;
                    autocompleteResult = result.items?.map((e) => nameTr ? e.nameTr : e.english).toList() ?? [];
                  }
                  return autocompleteResult;
                },
              );
              return Stream.fromFuture(listApiResult);
            }
          }
        },
        animationController: animationController,
        context: context,
        provinceCode: '',
      ),
    );
    animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onPrimary),
      onPressed: () async => onPressed(context),
    );
  }
}
