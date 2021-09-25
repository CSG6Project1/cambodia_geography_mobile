import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:flutter/material.dart';

class CgPopupMenu<T> extends StatefulWidget {
  const CgPopupMenu({
    Key? key,
    required this.child,
    this.items = const [],
    this.openOnLongPressed = true,
    this.positionLeft,
    this.positionRight,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final List<PopupMenuItem<T>> items;
  final bool openOnLongPressed;
  final double? positionLeft;
  final double? positionRight;
  final void Function(dynamic value) onPressed;

  @override
  _CgPopupMenuState createState() => _CgPopupMenuState<T>();
}

class _CgPopupMenuState<T> extends State<CgPopupMenu> with CgMediaQueryMixin {
  void onPressed(BuildContext context) async {
    if (widget.items.isEmpty) return;
    Offset offset = Offset(0.0, 0.0);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    T? result = await showMenu<T>(
      context: context,
      items: widget.items as List<PopupMenuItem<T>>,
      position: RelativeRect.fromLTRB(
        widget.positionLeft ?? (widget.positionRight != null ? ConfigConstant.margin0 : position.left),
        position.top,
        widget.positionRight ?? (widget.positionLeft != null ? ConfigConstant.margin0 : position.right),
        position.bottom,
      ),
    );
    widget.onPressed(result);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: widget.openOnLongPressed ? null : () => onPressed(context),
      onLongPress: widget.openOnLongPressed ? () => onPressed(context) : null,
    );
  }
}
