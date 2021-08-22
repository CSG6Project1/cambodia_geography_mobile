import 'dart:io';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/screens/search/search_history_storage.dart';
import 'package:cambodia_geography/services/apis/search/search_filter_api.dart';
import 'package:flutter/foundation.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:cambodia_geography/services/apis/search/search_api.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

class CgSearchDelegate extends SearchDelegate<String> {
  late PlacesApi placesApi;
  late SearchApi searchApi;
  PlaceModel? placeModel;
  PlaceListModel? placeList;
  String? provinceCode;

  final AnimationController animationController;
  final BuildContext context;
  final Future<List<dynamic>?> Function(String) onQueryChanged;
  final SearchHistoryStorage searchHistoryStorage = SearchHistoryStorage();

  CgSearchDelegate({
    required this.onQueryChanged,
    required this.animationController,
    required this.context,
    required this.provinceCode,
  });

  @override
  void showResults(BuildContext context) {
    if (query.isEmpty) return;
    // Navigator.push(context, MaterialPageRoute(builder: (context){
    //   return PlaceList(
    //   key: Key(query),
    //   onTap: (place) {},
    //   basePlacesApi: SearchApi(),
    //   keyword: query,
    // );
    // }));
    super.showResults(context);
    searchHistoryStorage.readList().then((value) {
      if (value == null) {
        searchHistoryStorage.writeList([query]);
      } else {
        if (value.contains(query)) return;
        value.insert(0, query);
        searchHistoryStorage.writeList(value);
      }
    });
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
      IconButton(
        icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.primary),
        onPressed: () {
          query = "";
        },
      ),
      IconButton(
        icon: Icon(Icons.tune, color: Theme.of(context).colorScheme.primary),
        onPressed: () {
          Navigator.of(context).pushNamed(RouteConfig.SEARCHFILTER).then((value) {
            if (value is PlaceModel) {
              print(value.toJson());
              placeModel = value;
              showResults(context);
            }
          });
        },
      ),
    ];
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
    return PlaceList(
      type: placeModel?.type == "restaurant" ? PlaceType.restaurant : PlaceType.place,
      provinceCode: placeModel?.provinceCode,
      districtCode: placeModel?.districtCode,
      villageCode: placeModel?.villageCode,
      communeCode: placeModel?.communeCode,
      key: Key(query),
      basePlacesApi: placeModel != null ? SearchFilterApi() : SearchApi(),
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

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<dynamic>?>(
      future: onQueryChanged(query),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SizedBox();
        }
        if (snapshot.hasData) {
          var suggestionList = snapshot.data ?? [];
          return Container(
            color: Theme.of(context).colorScheme.surface,
            child: ListView.builder(
              itemCount: suggestionList.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  query = removeAllHtmlTags(suggestionList[index]);
                  showResults(context);
                },
                onLongPressStart: (detail) {
                  var offset = detail.globalPosition;
                  final screenSize = MediaQuery.of(context).size;
                  showMenu(
                    position: RelativeRect.fromLTRB(
                      screenSize.width,
                      offset.dy - 24,
                      0,
                      screenSize.height - offset.dy,
                    ),
                    context: context,
                    items: <PopupMenuEntry>[
                      PopupMenuItem(
                        value: "",
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text("Delete"),
                          onTap: () async {
                            var selectedItem = suggestionList[index];
                            var list = await searchHistoryStorage.readList();
                            if (list?.contains(selectedItem) == true) {
                              list?.removeWhere((e) => e == selectedItem);
                              await searchHistoryStorage.writeList(list ?? []);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
                child: ListTile(
                  leading: query.isEmpty ? Icon(Icons.history) : Icon(Icons.search),
                  title: StyledText(text: suggestionList[index], style: TextStyle(), styles: {
                    "b": TextStyle(fontWeight: FontWeight.bold),
                  }),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }
}
