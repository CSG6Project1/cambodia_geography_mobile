import 'package:cambodia_geography/exports/exports.dart';
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
        onQueryChanged: (String query, PlaceType? type) async {
          if (query.isEmpty) {
            SearchHistoryStorage storage = SearchHistoryStorage();
            return storage.readList().then(
              (value) {
                List<AutocompleterModel>? result = value?.map((e) {
                  return AutocompleterModel(
                    khmer: "$e",
                    english: "$e",
                    id: "$e",
                    type: 'recent',
                  );
                }).toList();
                return result ?? [];
              },
            );
          } else {
            if (type == PlaceType.geo) {
              GeographySearchService service = GeographySearchService();
              List<AutocompleterModel> localResult = service.autocompletion(query);
              return localResult;
            } else {
              SearchAutocompleteApi autoCompleterApi = SearchAutocompleteApi();
              return await autoCompleterApi.fetchAutocompleters(keyword: query).then((value) {
                return value is AutocompleterListModel ? value.items ?? [] : [];
              });
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
      tooltip: MaterialLocalizations.of(context).searchFieldLabel,
      icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onPrimary),
      onPressed: () async => onPressed(context),
    );
  }
}
