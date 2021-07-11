import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  _NotFoundScreenState createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: CgAppBarTitle(title: "404"),
      ),
      body: Center(
        child: Text("404 Not Found"),
      ),
    );
  }
}
