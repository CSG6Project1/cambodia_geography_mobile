import 'package:flutter/material.dart';

mixin CgMediaQuery<T extends StatefulWidget> on State<T> {
  Size get screenSize => MediaQuery.of(context).size;
  EdgeInsets get viewInsets => MediaQuery.of(context).viewInsets;
  EdgeInsets get viewPadding => MediaQuery.of(context).viewPadding;
  EdgeInsets get mediaQueryPadding => MediaQuery.of(context).padding;
  MediaQueryData get mediaQueryData => MediaQuery.of(context);
}
