import 'package:flutter/material.dart';

class CgLoadMoreList extends StatefulWidget {
  const CgLoadMoreList({
    Key? key,
    required this.onEndScroll,
    required this.child,
  }) : super(key: key);

  final Future<void> Function() onEndScroll;
  final Widget child;

  @override
  _CgLoadMoreListState createState() => _CgLoadMoreListState();
}

class _CgLoadMoreListState extends State<CgLoadMoreList> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      child: widget.child,
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification && !_loading) {
          final pixels = scrollNotification.metrics.pixels;
          final maxScrollExtent = scrollNotification.metrics.maxScrollExtent;
          if (pixels >= maxScrollExtent - 100) onNearEndScroll();
        }
        return false;
      },
    );
  }

  Future<void> onNearEndScroll() async {
    _loading = true;
    await widget.onEndScroll();
    _loading = false;
  }
}
