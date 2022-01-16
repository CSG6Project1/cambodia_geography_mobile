import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/models/search/autocompleter_model.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/services/storages/search_history_storage.dart';
import 'package:cambodia_geography/services/apis/search/search_filter_api.dart';
import 'package:cambodia_geography/services/geography/navigator_to_geo_service.dart';
import 'package:cambodia_geography/utils/translation_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

class CgSearchDelegate extends SearchDelegate<String> {
  late PlacesApi placesApi;
  late SearchFilterApi searchFilterApi;
  PlaceModel? placeModel;
  PlaceListModel? placeList;
  String? provinceCode;

  final AnimationController animationController;
  final BuildContext context;
  final Future<List<dynamic>> Function(String, PlaceType?) onQueryChanged;
  final SearchHistoryStorage searchHistoryStorage = SearchHistoryStorage();

  static String get hintText => tr("hint.search_for_places");

  CgSearchDelegate({
    required this.onQueryChanged,
    required this.animationController,
    required this.context,
    required this.provinceCode,
    required this.placeModel,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  void showResults(BuildContext context) {
    if (query.isEmpty) return;
    super.showResults(context);
    searchHistoryStorage.readList().then(
      (value) {
        if (value == null) {
          searchHistoryStorage.writeList([query]);
        } else {
          if (value.contains(query)) return;
          value.insert(0, query);
          searchHistoryStorage.writeList(value);
        }
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      buildClearQueryButton(context),
      buildFilterButton(context),
    ];
  }

  Widget buildFilterButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.tune, color: Theme.of(context).colorScheme.primary),
      onPressed: () {
        Navigator.of(context).pushNamed(RouteConfig.SEARCHFILTER, arguments: placeModel).then(
          (value) {
            if (value is PlaceModel) {
              print(value.toJson());
              placeModel = value;
            }
          },
        );
      },
    );
  }

  Widget buildClearQueryButton(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AnimatedCrossFade(
        sizeCurve: Curves.ease,
        firstChild: Container(
          width: kToolbarHeight,
          height: kToolbarHeight,
          child: IconButton(
            icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              query = "";
            },
          ),
        ),
        secondChild: SizedBox(
          height: kToolbarHeight,
        ),
        crossFadeState: query.isNotEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: ConfigConstant.fadeDuration,
      ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    if (!kIsWeb && Platform.isAndroid) {
      return IconButton(
        icon: AnimatedIcon(
          color: Theme.of(context).colorScheme.primary,
          icon: AnimatedIcons.menu_arrow,
          progress: animationController,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      return BackButton(
        color: Theme.of(context).colorScheme.primary,
      );
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    if (placeModel?.placeType() == PlaceType.geo) {
      return buildSuggestions(context);
    } else {
      return PlaceList(
        type: placeModel?.placeType(),
        provinceCode: placeModel?.provinceCode,
        districtCode: placeModel?.districtCode,
        villageCode: placeModel?.villageCode,
        communeCode: placeModel?.communeCode,
        key: Key(query),
        basePlacesApi: placeModel != null ? SearchFilterApi() : SearchFilterApi(),
        keyword: query,
        onTap: (place) {
          Navigator.pushNamed(
            context,
            RouteConfig.PLACEDETAIL,
            arguments: place,
          );
        },
      );
    }
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List?>(
      future: onQueryChanged(query, placeModel?.placeType()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> suggestionList = snapshot.data ?? [];
          AutocompleterModel? item = suggestionList.isNotEmpty ? suggestionList.first : null;

          if (item?.type == "recent" && query.isNotEmpty) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          return Container(
            color: Theme.of(context).colorScheme.surface,
            child: ListView.builder(
              itemCount: suggestionList.length,
              itemBuilder: (context, index) {
                if (suggestionList[index] is AutocompleterModel?) {
                  AutocompleterModel? item = suggestionList[index];

                  String? nameTr = item?.english?.contains("<b>") == true ? item?.english : item?.khmer;
                  String? type = suggestionList[index]?.type?.toLowerCase();

                  Text? subtitle = type != null && item?.shouldDisplayType == true
                      ? Text(
                          tr('geo.' + type) + ": " + numberTr(item!.id.toString()),
                        )
                      : null;

                  return Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: ListTile(
                      onTap: () => onSuggestionPressed(nameTr, item, context, suggestionList),
                      onLongPress: () => onSuggestionLongPress(nameTr, item, context, suggestionList),
                      leading: item?.type == "recent"
                          ? Icon(Icons.history)
                          : Icon(isGeoSearch ? Icons.explore_outlined : Icons.search),
                      title: StyledText(
                        text: nameTr ?? "",
                        style: TextStyle(),
                        tags: {
                          "b": StyledTextActionTag(
                            (_, __) {},
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        },
                      ),
                      subtitle: subtitle,
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  bool get isGeoSearch => placeModel?.placeType() == PlaceType.geo;

  Future<void> onSuggestionLongPress(
    String? nameTr,
    AutocompleterModel? item,
    BuildContext context,
    List<dynamic> suggestionList,
  ) async {
    if (query.isEmpty) {
      OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: tr("msg.are_you_sure_to_delete"),
      );
      if (result == OkCancelResult.ok) {
        String? selectedItem = item?.nameTr;
        List<dynamic>? list = await searchHistoryStorage.readList();
        if (list?.contains(selectedItem) == true) {
          list?.removeWhere((e) => e == selectedItem);
          await searchHistoryStorage.writeList(list ?? []);
        }
      }
    } else {
      onSuggestionPressed(nameTr, item, context, suggestionList);
    }
  }

  void onSuggestionPressed(
    String? nameTr,
    AutocompleterModel? item,
    BuildContext context,
    List<dynamic> suggestionList,
  ) async {
    if (placeModel?.placeType() == PlaceType.geo && item?.id != null && item?.type != "recent") {
      await NavigatorToGeoService().exec(context: context, code: item!.id!);
    } else {
      if (nameTr == null) return;
      query = removeAllHtmlTags(nameTr);
      showResults(context);
      searchHistoryStorage.readList().then(
        (value) {
          if (query != suggestionList[0]?.nameTr && value != null) {
            value.remove(query);
            value.insert(0, query);
            searchHistoryStorage.writeList(value);
          }
        },
      );
    }
  }
}
