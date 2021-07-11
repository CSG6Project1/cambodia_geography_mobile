import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({Key? key}) : super(key: key);

  @override
  _SearchFilterScreenState createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: CgAppBarTitle(title: "Search Screen"),
      ),
    );
  }
}
