import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/models/search/autocompleter_list_model.dart';
import 'package:cambodia_geography/screens/search/cg_search_delegate.dart';
import 'package:cambodia_geography/screens/search/search_history_storage.dart';
import 'package:cambodia_geography/services/apis/search/search_autocomplete_api.dart';

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
        onQueryChanged: (String query) async {
          if (query.isEmpty) {
            SearchHistoryStorage storage = SearchHistoryStorage();
            List<dynamic>? value = await storage.readList();
            return value ?? [];
          } else {
            var autoCompleterApi = SearchAutocompleteApi();
            var result = await autoCompleterApi.fetchAutocompleters(keyword: query);
            if (autoCompleterApi.success() && result is AutocompleterListModel) {
              bool khmer = result.items?[0].khmer?.contains("<b>") == true;
              return result.items?.map((e) => khmer ? e.khmer : e.english).toList();
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
