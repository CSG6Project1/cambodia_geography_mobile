import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:flutter/material.dart';

class CgPopupMenu<T> extends StatefulWidget {
  const CgPopupMenu({
    Key? key,
    required this.child,
    this.items = const [],
    this.openOnLongPressed = true,
    this.positinLeft,
    this.positinRight,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final List<PopupMenuItem<T>> items;
  final bool openOnLongPressed;
  final double? positinLeft;
  final double? positinRight;
  final void Function(dynamic value) onPressed;

  @override
  _CgPopupMenuState createState() => _CgPopupMenuState<T>();
}

class _CgPopupMenuState<T> extends State<CgPopupMenu> with CgMediaQueryMixin {
  Offset? _tapDownPosition;

  void onPressed(BuildContext context) async {
    if (widget.items.isEmpty) return;
    dynamic overlay = Overlay.of(context)?.context.findRenderObject();
    if (overlay is RenderBox) {
      dynamic result = await showMenu<T>(
        context: context,
        items: widget.items as List<PopupMenuItem<T>>,
        position: RelativeRect.fromLTRB(
          widget.positinLeft ?? ConfigConstant.margin2,
          _tapDownPosition?.dy ?? 0,
          widget.positinRight ?? ConfigConstant.margin2,
          overlay.size.height - (_tapDownPosition?.dy ?? 0),
        ),
      );
      widget.onPressed(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: widget.openOnLongPressed ? null : () => onPressed(context),
      onTapDown: (details) => _tapDownPosition = details.globalPosition,
      onLongPress: widget.openOnLongPressed ? () => onPressed(context) : null,
    );
  }
}
