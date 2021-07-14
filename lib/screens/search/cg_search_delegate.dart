import 'package:cambodia_geography/screens/search/search_filter_screen.dart';
import 'package:flutter/material.dart';

class CgSearchDelegate extends SearchDelegate<String> {
  static const DataPlaces = [
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

  final searchHistory = [
    "កណ្ដាល",
    "កំពង់ចាម",
    "កំពង់ធំ",
    "ឧត្តរមានជ័យ",
    "កែប",
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.red),
        onPressed: () {
          query = "";
        },
      ),
      IconButton(
        icon: const Icon(Icons.tune, color: Colors.red),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context)=>const SearchFilterScreen()));
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        color: Colors.red,
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
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
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? searchHistory
        : DataPlaces.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: const Icon(Icons.history),
        title: Text(suggestionList[index]),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 15,
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
