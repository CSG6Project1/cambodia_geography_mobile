import 'dart:io';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/search/search_history_storage.dart';
import 'package:flutter/material.dart';

class CgSearchDelegate extends SearchDelegate<String> {
  final AnimationController animationController;
  final BuildContext context;
  final Future<List<dynamic>?> Function(String) onQueryChanged;
  final SearchHistoryStorage searchHistoryStorage = SearchHistoryStorage();

  CgSearchDelegate({
    required this.onQueryChanged,
    required this.animationController,
    required this.context,
  });

  static const dataPlaces = [
    "កំពង់ចាម",
    "បន្ទាយមានជ័យ",
    "បាត់ដំបង",
    "កំពង់ឆ្នាំង",
    "កំពង់ស្ពឺ",
    "កំពង់ធំ",
    "កំពត",
    "កណ្តាល",
    "កោះកុង",
    "ក្រចេះ",
    "មណ្ឌលគិរី",
    "ភ្នំពេញ",
    "ព្រះវិហារ",
    "ព្រៃវែង",
    "ពោធិ៍សាត់",
    "រតនគិរី",
    "សៀមរាប",
    "ព្រះសីហនុ",
    "ស្ទឹងត្រែង",
    "ស្វាយរៀង",
    "តាកែវ",
    "ឧត្តរមានជ័យ",
    "កែប",
    "ប៉ៃលិន",
    "ត្បូងឃ្មុំ",
  ];

  @override
  void showResults(BuildContext context) {
    if (query.isEmpty) return;
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
            if (value is PlaceModel) print(value.toJson());
          });
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    if (Platform.isAndroid) {
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
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Container(
          color: Colors.white,
          height: 50,
          width: 50,
          child: Card(
            color: Colors.red,
            shape: const StadiumBorder(),
            child: Center(
              child: Text(query),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<dynamic>?>(
      future: onQueryChanged(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var suggestionList = snapshot.data ?? [];
          return Container(
            color: Theme.of(context).colorScheme.surface,
            child: ListView.builder(
              itemCount: suggestionList.length,
              itemBuilder: (context, index) => GestureDetector(
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
                  leading: const Icon(Icons.history),
                  title: Text(suggestionList[index]),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    showResults(context);
                  },
                ),
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
