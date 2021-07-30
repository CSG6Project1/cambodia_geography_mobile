import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:flutter/material.dart';

class CgPopupMenu extends StatefulWidget {
  const CgPopupMenu({
    Key? key,
    required this.child,
    this.items = const [],
  }) : super(key: key);

  final Widget child;
  final List<PopupMenuItem> items;

  @override
  _CgPopupMenuState createState() => _CgPopupMenuState();
}

class _CgPopupMenuState extends State<CgPopupMenu> with CgMediaQueryMixin {
  Offset? _tapDownPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTapDown: (details) => _tapDownPosition = details.globalPosition,
      onLongPress: () async {
        dynamic overlay = Overlay.of(context)?.context.findRenderObject();
        if (overlay is RenderBox) {
          return await showMenu<dynamic>(
            context: context,
            items: widget.items,
            position: RelativeRect.fromLTRB(
              ConfigConstant.margin2,
              _tapDownPosition?.dy ?? 0,
              ConfigConstant.margin2,
              overlay.size.height - (_tapDownPosition?.dy ?? 0),
            ),
          );
        }
      },
    );
  }
}
